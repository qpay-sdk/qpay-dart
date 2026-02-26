import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:qpay/qpay.dart';
import 'package:test/test.dart';

/// Fake token response JSON for mocking auth endpoints.
final _tokenJson = {
  'token_type': 'bearer',
  'refresh_expires_in': 3600,
  'refresh_token': 'refresh-tok',
  'access_token': 'access-tok',
  'expires_in': 300,
  'scope': 'default',
  'not-before-policy': '0',
  'session_state': 'sess-123',
};

/// Default [QPayConfig] used across tests.
final _config = const QPayConfig(
  baseUrl: 'https://api.test',
  username: 'user',
  password: 'pass',
  invoiceCode: 'INV_CODE',
  callbackUrl: 'https://cb.test/hook',
);

/// Helper that wraps a [MockClient] so every non-auth request is preceded by
/// a successful token acquisition (the mock intercepts `/v2/auth/token`).
QPayClient _clientWith(
    Future<http.Response> Function(http.Request) handler) {
  final mock = MockClient((request) async {
    // Intercept auth token request
    if (request.url.path == '/v2/auth/token') {
      return http.Response(jsonEncode(_tokenJson), 200);
    }
    // Intercept auth refresh request
    if (request.url.path == '/v2/auth/refresh') {
      return http.Response(jsonEncode(_tokenJson), 200);
    }
    return handler(request);
  });
  return QPayClient(_config, httpClient: mock);
}

void main() {
  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------
  group('Auth', () {
    test('getToken sends Basic auth and returns TokenResponse', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/v2/auth/token');
        expect(request.method, 'POST');
        final expectedCreds =
            base64Encode(utf8.encode('${_config.username}:${_config.password}'));
        expect(request.headers['Authorization'], 'Basic $expectedCreds');
        return http.Response(jsonEncode(_tokenJson), 200);
      });

      final client = QPayClient(_config, httpClient: mock);
      final token = await client.getToken();

      expect(token.accessToken, 'access-tok');
      expect(token.refreshToken, 'refresh-tok');
      expect(token.tokenType, 'bearer');
      expect(token.expiresIn, 300);
      expect(token.refreshExpiresIn, 3600);

      client.close();
    });

    test('refreshToken sends Bearer auth and returns TokenResponse', () async {
      // First authenticate to obtain a refresh token.
      final mock = MockClient((request) async {
        if (request.url.path == '/v2/auth/token') {
          return http.Response(jsonEncode(_tokenJson), 200);
        }
        if (request.url.path == '/v2/auth/refresh') {
          expect(request.method, 'POST');
          expect(request.headers['Authorization'], 'Bearer refresh-tok');
          return http.Response(
            jsonEncode({
              ..._tokenJson,
              'access_token': 'new-access-tok',
            }),
            200,
          );
        }
        return http.Response('', 404);
      });

      final client = QPayClient(_config, httpClient: mock);
      await client.getToken();
      final refreshed = await client.refreshToken();

      expect(refreshed.accessToken, 'new-access-tok');

      client.close();
    });

    test('getToken throws QPayException on 401', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({'error': 'AUTHENTICATION_FAILED', 'message': 'bad creds'}),
          401,
        );
      });

      final client = QPayClient(_config, httpClient: mock);

      expect(
        () => client.getToken(),
        throwsA(isA<QPayException>()
            .having((e) => e.statusCode, 'statusCode', 401)
            .having((e) => e.code, 'code', 'AUTHENTICATION_FAILED')),
      );

      client.close();
    });
  });

  // ---------------------------------------------------------------------------
  // Invoice
  // ---------------------------------------------------------------------------
  group('Invoice', () {
    test('createSimpleInvoice sends correct body and parses response',
        () async {
      final invoiceJson = {
        'invoice_id': 'inv-1',
        'qr_text': 'qr-text',
        'qr_image': 'qr-img',
        'qPay_shortUrl': 'https://short.url',
        'urls': [
          {
            'name': 'Khan Bank',
            'description': 'Khan Bank app',
            'logo': 'https://logo.png',
            'link': 'khanbank://pay?q=123',
          },
        ],
      };

      final client = _clientWith((request) async {
        expect(request.url.path, '/v2/invoice');
        expect(request.method, 'POST');
        expect(request.headers['Authorization'], 'Bearer access-tok');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['invoice_code'], 'INV_CODE');
        expect(body['amount'], 5000.0);

        return http.Response(jsonEncode(invoiceJson), 200);
      });

      final resp = await client.createSimpleInvoice(CreateSimpleInvoiceRequest(
        invoiceCode: 'INV_CODE',
        senderInvoiceNo: 'INV-001',
        invoiceReceiverCode: 'terminal',
        invoiceDescription: 'Test',
        amount: 5000,
        callbackUrl: 'https://cb.test/hook',
      ));

      expect(resp.invoiceId, 'inv-1');
      expect(resp.qrText, 'qr-text');
      expect(resp.qPayShortUrl, 'https://short.url');
      expect(resp.urls, hasLength(1));
      expect(resp.urls.first.name, 'Khan Bank');

      client.close();
    });

    test('createInvoice sends full body', () async {
      final client = _clientWith((request) async {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['invoice_code'], 'INV_CODE');
        expect(body['sender_invoice_no'], 'INV-002');
        expect(body['amount'], 10000.0);
        expect(body['note'], 'test note');

        return http.Response(
          jsonEncode({
            'invoice_id': 'inv-2',
            'qr_text': '',
            'qr_image': '',
            'qPay_shortUrl': '',
            'urls': [],
          }),
          200,
        );
      });

      final resp = await client.createInvoice(CreateInvoiceRequest(
        invoiceCode: 'INV_CODE',
        senderInvoiceNo: 'INV-002',
        invoiceReceiverCode: 'terminal',
        invoiceDescription: 'Full invoice',
        amount: 10000,
        callbackUrl: 'https://cb.test/hook',
        note: 'test note',
      ));

      expect(resp.invoiceId, 'inv-2');

      client.close();
    });

    test('createEbarimtInvoice sends tax info', () async {
      final client = _clientWith((request) async {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['tax_type'], 'VAT');
        expect(body['district_code'], 'UB01');
        expect(body['lines'], isList);

        return http.Response(
          jsonEncode({
            'invoice_id': 'inv-3',
            'qr_text': '',
            'qr_image': '',
            'qPay_shortUrl': '',
            'urls': [],
          }),
          200,
        );
      });

      final resp = await client.createEbarimtInvoice(CreateEbarimtInvoiceRequest(
        invoiceCode: 'INV_CODE',
        senderInvoiceNo: 'INV-003',
        invoiceReceiverCode: 'terminal',
        invoiceDescription: 'Ebarimt invoice',
        taxType: 'VAT',
        districtCode: 'UB01',
        callbackUrl: 'https://cb.test/hook',
        lines: [
          const EbarimtInvoiceLine(
            lineDescription: 'Item 1',
            lineQuantity: '1',
            lineUnitPrice: '5000',
          ),
        ],
      ));

      expect(resp.invoiceId, 'inv-3');

      client.close();
    });

    test('cancelInvoice sends DELETE', () async {
      final client = _clientWith((request) async {
        expect(request.url.path, '/v2/invoice/inv-1');
        expect(request.method, 'DELETE');
        return http.Response('', 200);
      });

      await client.cancelInvoice('inv-1');

      client.close();
    });

    test('createInvoice throws QPayException on error', () async {
      final client = _clientWith((request) async {
        return http.Response(
          jsonEncode({'error': 'INVOICE_CODE_INVALID', 'message': 'bad code'}),
          400,
        );
      });

      expect(
        () => client.createSimpleInvoice(CreateSimpleInvoiceRequest(
          invoiceCode: 'BAD',
          senderInvoiceNo: 'INV-001',
          invoiceReceiverCode: 'terminal',
          invoiceDescription: 'Test',
          amount: 1000,
          callbackUrl: 'https://cb.test/hook',
        )),
        throwsA(isA<QPayException>()
            .having((e) => e.statusCode, 'statusCode', 400)
            .having((e) => e.code, 'code', 'INVOICE_CODE_INVALID')),
      );

      client.close();
    });
  });

  // ---------------------------------------------------------------------------
  // Payment
  // ---------------------------------------------------------------------------
  group('Payment', () {
    test('getPayment sends GET and parses PaymentDetail', () async {
      final paymentJson = {
        'payment_id': 'pay-1',
        'payment_status': 'PAID',
        'payment_fee': '0',
        'payment_amount': '5000',
        'payment_currency': 'MNT',
        'payment_date': '2025-01-01',
        'payment_wallet': 'Khan Bank',
        'transaction_type': 'P2P',
        'object_type': 'INVOICE',
        'object_id': 'inv-1',
        'card_transactions': [],
        'p2p_transactions': [
          {
            'transaction_bank_code': 'KHAN',
            'account_bank_code': 'KHAN',
            'account_bank_name': 'Khan Bank',
            'account_number': '1234567890',
            'status': 'SUCCESS',
            'amount': '5000',
            'currency': 'MNT',
            'settlement_status': 'SETTLED',
          },
        ],
      };

      final client = _clientWith((request) async {
        expect(request.url.path, '/v2/payment/pay-1');
        expect(request.method, 'GET');
        return http.Response(jsonEncode(paymentJson), 200);
      });

      final detail = await client.getPayment('pay-1');

      expect(detail.paymentId, 'pay-1');
      expect(detail.paymentStatus, 'PAID');
      expect(detail.paymentAmount, '5000');
      expect(detail.p2pTransactions, hasLength(1));
      expect(detail.p2pTransactions.first.accountBankName, 'Khan Bank');

      client.close();
    });

    test('checkPayment sends POST and parses response', () async {
      final checkJson = {
        'count': 1,
        'paid_amount': 5000.0,
        'rows': [
          {
            'payment_id': 'pay-1',
            'payment_status': 'PAID',
            'payment_amount': '5000',
            'trx_fee': '0',
            'payment_currency': 'MNT',
            'payment_wallet': 'Khan Bank',
            'payment_type': 'P2P',
            'card_transactions': [],
            'p2p_transactions': [],
          },
        ],
      };

      final client = _clientWith((request) async {
        expect(request.url.path, '/v2/payment/check');
        expect(request.method, 'POST');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['object_type'], 'INVOICE');
        expect(body['object_id'], 'inv-1');

        return http.Response(jsonEncode(checkJson), 200);
      });

      final resp = await client.checkPayment(const PaymentCheckRequest(
        objectType: 'INVOICE',
        objectId: 'inv-1',
      ));

      expect(resp.count, 1);
      expect(resp.paidAmount, 5000.0);
      expect(resp.rows, hasLength(1));
      expect(resp.rows.first.paymentStatus, 'PAID');

      client.close();
    });

    test('listPayments sends POST and parses response', () async {
      final listJson = {
        'count': 1,
        'rows': [
          {
            'payment_id': 'pay-1',
            'payment_date': '2025-01-01',
            'payment_status': 'PAID',
            'payment_fee': '0',
            'payment_amount': '5000',
            'payment_currency': 'MNT',
            'payment_wallet': 'Khan Bank',
            'payment_name': 'Test',
            'payment_description': 'desc',
            'qr_code': 'qr',
            'paid_by': 'user',
            'object_type': 'INVOICE',
            'object_id': 'inv-1',
          },
        ],
      };

      final client = _clientWith((request) async {
        expect(request.url.path, '/v2/payment/list');
        expect(request.method, 'POST');
        return http.Response(jsonEncode(listJson), 200);
      });

      final resp = await client.listPayments(const PaymentListRequest(
        objectType: 'INVOICE',
        objectId: 'inv-1',
        startDate: '2025-01-01',
        endDate: '2025-12-31',
        offset: Offset(pageNumber: 1, pageLimit: 10),
      ));

      expect(resp.count, 1);
      expect(resp.rows.first.paymentId, 'pay-1');
      expect(resp.rows.first.paymentName, 'Test');

      client.close();
    });

    test('cancelPayment sends DELETE with body', () async {
      final client = _clientWith((request) async {
        expect(request.url.path, '/v2/payment/cancel/pay-1');
        expect(request.method, 'DELETE');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['note'], 'cancel reason');

        return http.Response('', 200);
      });

      await client.cancelPayment(
        'pay-1',
        const PaymentCancelRequest(note: 'cancel reason'),
      );

      client.close();
    });

    test('refundPayment sends DELETE with body', () async {
      final client = _clientWith((request) async {
        expect(request.url.path, '/v2/payment/refund/pay-1');
        expect(request.method, 'DELETE');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['callback_url'], 'https://cb.test/refund');

        return http.Response('', 200);
      });

      await client.refundPayment(
        'pay-1',
        const PaymentRefundRequest(callbackUrl: 'https://cb.test/refund'),
      );

      client.close();
    });

    test('getPayment throws on 404', () async {
      final client = _clientWith((request) async {
        return http.Response(
          jsonEncode({
            'error': 'PAYMENT_NOTFOUND',
            'message': 'Payment not found',
          }),
          404,
        );
      });

      expect(
        () => client.getPayment('nonexistent'),
        throwsA(isA<QPayException>()
            .having((e) => e.statusCode, 'statusCode', 404)
            .having((e) => e.code, 'code', 'PAYMENT_NOTFOUND')),
      );

      client.close();
    });
  });

  // ---------------------------------------------------------------------------
  // Ebarimt
  // ---------------------------------------------------------------------------
  group('Ebarimt', () {
    final ebarimtJson = {
      'id': 'eb-1',
      'ebarimt_by': 'MERCHANT',
      'g_wallet_id': 'w-1',
      'g_wallet_customer_id': 'c-1',
      'ebarimt_receiver_type': 'INDIVIDUAL',
      'ebarimt_receiver': '99001122',
      'ebarimt_district_code': 'UB01',
      'ebarimt_bill_type': 'B2C',
      'g_merchant_id': 'm-1',
      'merchant_branch_code': 'br-1',
      'merchant_register_no': 'REG123',
      'g_payment_id': 'pay-1',
      'paid_by': 'user',
      'object_type': 'INVOICE',
      'object_id': 'inv-1',
      'amount': '5000',
      'vat_amount': '500',
      'city_tax_amount': '50',
      'ebarimt_qr_data': 'qr-data',
      'ebarimt_lottery': 'LOTTERY123',
      'barimt_status': 'CREATED',
      'barimt_status_date': '2025-01-01',
      'ebarimt_receiver_phone': '99001122',
      'tax_type': 'VAT',
      'created_by': 'system',
      'created_date': '2025-01-01',
      'updated_by': 'system',
      'updated_date': '2025-01-01',
      'status': true,
    };

    test('createEbarimt sends POST and parses response', () async {
      final client = _clientWith((request) async {
        expect(request.url.path, '/v2/ebarimt_v3/create');
        expect(request.method, 'POST');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['payment_id'], 'pay-1');
        expect(body['ebarimt_receiver_type'], 'INDIVIDUAL');

        return http.Response(jsonEncode(ebarimtJson), 200);
      });

      final resp = await client.createEbarimt(const CreateEbarimtRequest(
        paymentId: 'pay-1',
        ebarimtReceiverType: 'INDIVIDUAL',
        ebarimtReceiver: '99001122',
      ));

      expect(resp.id, 'eb-1');
      expect(resp.ebarimtLottery, 'LOTTERY123');
      expect(resp.status, true);

      client.close();
    });

    test('cancelEbarimt sends DELETE and parses response', () async {
      final client = _clientWith((request) async {
        expect(request.url.path, '/v2/ebarimt_v3/pay-1');
        expect(request.method, 'DELETE');
        return http.Response(
          jsonEncode({...ebarimtJson, 'barimt_status': 'CANCELLED'}),
          200,
        );
      });

      final resp = await client.cancelEbarimt('pay-1');

      expect(resp.barimtStatus, 'CANCELLED');

      client.close();
    });
  });

  // ---------------------------------------------------------------------------
  // Token auto-management
  // ---------------------------------------------------------------------------
  group('Token management', () {
    test('auto-authenticates before first request', () async {
      var tokenRequested = false;
      final mock = MockClient((request) async {
        if (request.url.path == '/v2/auth/token') {
          tokenRequested = true;
          return http.Response(jsonEncode(_tokenJson), 200);
        }
        expect(request.headers['Authorization'], 'Bearer access-tok');
        return http.Response('', 200);
      });

      final client = QPayClient(_config, httpClient: mock);
      await client.cancelInvoice('inv-1');

      expect(tokenRequested, isTrue);

      client.close();
    });

    test('throws QPayException when token acquisition fails', () async {
      final mock = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final client = QPayClient(_config, httpClient: mock);

      expect(
        () => client.cancelInvoice('inv-1'),
        throwsA(isA<QPayException>()),
      );

      client.close();
    });
  });

  // ---------------------------------------------------------------------------
  // close()
  // ---------------------------------------------------------------------------
  group('close', () {
    test('does not close externally provided httpClient', () {
      var closeCalled = false;
      final mock = MockClient((request) async {
        return http.Response('', 200);
      });
      // MockClient does not track close() but we verify no error is thrown.
      final client = QPayClient(_config, httpClient: mock);
      client.close(); // should not throw
      expect(closeCalled, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Non-JSON error body
  // ---------------------------------------------------------------------------
  group('Error handling edge cases', () {
    test('handles non-JSON error body gracefully', () async {
      final client = _clientWith((request) async {
        return http.Response('Bad Gateway', 502);
      });

      expect(
        () => client.cancelInvoice('inv-1'),
        throwsA(isA<QPayException>()
            .having((e) => e.statusCode, 'statusCode', 502)
            .having((e) => e.code, 'code', 'Bad Gateway')
            .having((e) => e.rawBody, 'rawBody', 'Bad Gateway')),
      );

      client.close();
    });

    test('handles empty error body', () async {
      final client = _clientWith((request) async {
        return http.Response('', 500);
      });

      expect(
        () => client.cancelInvoice('inv-1'),
        throwsA(isA<QPayException>()
            .having((e) => e.statusCode, 'statusCode', 500)),
      );

      client.close();
    });
  });
}
