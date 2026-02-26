import 'package:qpay/qpay.dart';
import 'package:test/test.dart';

void main() {
  // ---------------------------------------------------------------------------
  // TokenResponse
  // ---------------------------------------------------------------------------
  group('TokenResponse', () {
    test('fromJson parses all fields', () {
      final json = {
        'token_type': 'bearer',
        'refresh_expires_in': 3600,
        'refresh_token': 'ref-tok',
        'access_token': 'acc-tok',
        'expires_in': 300,
        'scope': 'default',
        'not-before-policy': '0',
        'session_state': 'sess-abc',
      };

      final token = TokenResponse.fromJson(json);

      expect(token.tokenType, 'bearer');
      expect(token.refreshExpiresIn, 3600);
      expect(token.refreshToken, 'ref-tok');
      expect(token.accessToken, 'acc-tok');
      expect(token.expiresIn, 300);
      expect(token.scope, 'default');
      expect(token.notBeforePolicy, '0');
      expect(token.sessionState, 'sess-abc');
    });

    test('fromJson handles missing fields with defaults', () {
      final token = TokenResponse.fromJson(<String, dynamic>{});

      expect(token.tokenType, '');
      expect(token.refreshExpiresIn, 0);
      expect(token.refreshToken, '');
      expect(token.accessToken, '');
      expect(token.expiresIn, 0);
      expect(token.scope, '');
      expect(token.notBeforePolicy, '');
      expect(token.sessionState, '');
    });

    test('toJson produces correct map', () {
      const token = TokenResponse(
        tokenType: 'bearer',
        refreshExpiresIn: 3600,
        refreshToken: 'ref',
        accessToken: 'acc',
        expiresIn: 300,
        scope: 'default',
        notBeforePolicy: '0',
        sessionState: 'sess',
      );

      final json = token.toJson();
      expect(json['token_type'], 'bearer');
      expect(json['refresh_expires_in'], 3600);
      expect(json['access_token'], 'acc');
      expect(json['not-before-policy'], '0');
    });

    test('roundtrip fromJson -> toJson preserves data', () {
      final original = {
        'token_type': 'bearer',
        'refresh_expires_in': 7200,
        'refresh_token': 'r-tok',
        'access_token': 'a-tok',
        'expires_in': 600,
        'scope': 'openid',
        'not-before-policy': '1',
        'session_state': 'state-1',
      };

      final roundtrip = TokenResponse.fromJson(original).toJson();
      expect(roundtrip, original);
    });
  });

  // ---------------------------------------------------------------------------
  // Address
  // ---------------------------------------------------------------------------
  group('Address', () {
    test('fromJson parses all fields', () {
      final json = {
        'city': 'Ulaanbaatar',
        'district': 'KHN',
        'street': 'Main St',
        'building': '101',
        'address': 'Full address',
        'zipcode': '14200',
        'longitude': '106.9',
        'latitude': '47.9',
      };

      final addr = Address.fromJson(json);
      expect(addr.city, 'Ulaanbaatar');
      expect(addr.district, 'KHN');
      expect(addr.zipcode, '14200');
    });

    test('toJson omits null fields', () {
      const addr = Address(city: 'UB');
      final json = addr.toJson();
      expect(json, {'city': 'UB'});
      expect(json.containsKey('district'), isFalse);
    });

    test('roundtrip', () {
      final original = {
        'city': 'UB',
        'district': 'KHN',
        'street': 'St',
        'building': '1',
        'address': 'addr',
        'zipcode': '14200',
        'longitude': '106.9',
        'latitude': '47.9',
      };
      final roundtrip = Address.fromJson(original).toJson();
      expect(roundtrip, original);
    });
  });

  // ---------------------------------------------------------------------------
  // SenderBranchData
  // ---------------------------------------------------------------------------
  group('SenderBranchData', () {
    test('fromJson with nested Address', () {
      final json = {
        'register': 'REG001',
        'name': 'Branch 1',
        'email': 'b@test.com',
        'phone': '99001122',
        'address': {'city': 'UB'},
      };

      final branch = SenderBranchData.fromJson(json);
      expect(branch.register, 'REG001');
      expect(branch.address, isNotNull);
      expect(branch.address!.city, 'UB');
    });

    test('toJson omits null fields', () {
      const branch = SenderBranchData(name: 'Test');
      final json = branch.toJson();
      expect(json, {'name': 'Test'});
    });
  });

  // ---------------------------------------------------------------------------
  // SenderStaffData
  // ---------------------------------------------------------------------------
  group('SenderStaffData', () {
    test('fromJson and toJson', () {
      final json = {'name': 'John', 'email': 'j@test.com', 'phone': '1234'};
      final staff = SenderStaffData.fromJson(json);
      expect(staff.name, 'John');
      expect(staff.toJson(), json);
    });

    test('toJson omits null fields', () {
      const staff = SenderStaffData(name: 'Jane');
      expect(staff.toJson(), {'name': 'Jane'});
    });
  });

  // ---------------------------------------------------------------------------
  // InvoiceReceiverData
  // ---------------------------------------------------------------------------
  group('InvoiceReceiverData', () {
    test('fromJson with address', () {
      final json = {
        'register': 'RCV001',
        'name': 'Receiver',
        'email': 'r@test.com',
        'phone': '88001122',
        'address': {'city': 'UB', 'district': 'BZD'},
      };
      final rcv = InvoiceReceiverData.fromJson(json);
      expect(rcv.register, 'RCV001');
      expect(rcv.address!.district, 'BZD');
    });
  });

  // ---------------------------------------------------------------------------
  // Account
  // ---------------------------------------------------------------------------
  group('Account', () {
    test('fromJson and toJson roundtrip', () {
      final json = {
        'account_bank_code': 'KHAN',
        'account_number': '1234567890',
        'iban_number': 'MN12345',
        'account_name': 'Test Account',
        'account_currency': 'MNT',
        'is_default': true,
      };

      final acc = Account.fromJson(json);
      expect(acc.accountBankCode, 'KHAN');
      expect(acc.isDefault, true);
      expect(acc.toJson(), json);
    });
  });

  // ---------------------------------------------------------------------------
  // Transaction
  // ---------------------------------------------------------------------------
  group('Transaction', () {
    test('fromJson with accounts list', () {
      final json = {
        'description': 'Payment for order',
        'amount': '5000',
        'accounts': [
          {
            'account_bank_code': 'KHAN',
            'account_number': '123',
            'iban_number': '',
            'account_name': 'Acc',
            'account_currency': 'MNT',
            'is_default': false,
          },
        ],
      };

      final txn = Transaction.fromJson(json);
      expect(txn.description, 'Payment for order');
      expect(txn.accounts, hasLength(1));
      expect(txn.accounts!.first.accountBankCode, 'KHAN');
    });

    test('toJson omits null accounts', () {
      const txn = Transaction(description: 'desc', amount: '100');
      final json = txn.toJson();
      expect(json.containsKey('accounts'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // TaxEntry
  // ---------------------------------------------------------------------------
  group('TaxEntry', () {
    test('fromJson and toJson', () {
      final json = {
        'tax_code': 'VAT',
        'description': 'VAT 10%',
        'amount': 500.0,
      };

      final entry = TaxEntry.fromJson(json);
      expect(entry.taxCode, 'VAT');
      expect(entry.amount, 500.0);
    });

    test('toJson omits null optional fields', () {
      const entry = TaxEntry(description: 'Tax', amount: 100.0);
      final json = entry.toJson();
      expect(json.containsKey('tax_code'), isFalse);
      expect(json['description'], 'Tax');
      expect(json['amount'], 100.0);
    });
  });

  // ---------------------------------------------------------------------------
  // InvoiceLine
  // ---------------------------------------------------------------------------
  group('InvoiceLine', () {
    test('fromJson with taxes', () {
      final json = {
        'tax_product_code': 'PROD001',
        'line_description': 'Widget',
        'line_quantity': '2',
        'line_unit_price': '5000',
        'taxes': [
          {'description': 'VAT', 'amount': 1000.0},
        ],
      };

      final line = InvoiceLine.fromJson(json);
      expect(line.taxProductCode, 'PROD001');
      expect(line.lineDescription, 'Widget');
      expect(line.taxes, hasLength(1));
      expect(line.taxes!.first.amount, 1000.0);
    });

    test('toJson roundtrip', () {
      const line = InvoiceLine(
        lineDescription: 'Item',
        lineQuantity: '1',
        lineUnitPrice: '3000',
      );
      final json = line.toJson();
      expect(json['line_description'], 'Item');
      expect(json.containsKey('taxes'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // EbarimtInvoiceLine
  // ---------------------------------------------------------------------------
  group('EbarimtInvoiceLine', () {
    test('fromJson and toJson', () {
      final json = {
        'tax_product_code': 'TP01',
        'line_description': 'Service',
        'barcode': 'BC001',
        'line_quantity': '1',
        'line_unit_price': '10000',
        'classification_code': 'CL01',
      };

      final line = EbarimtInvoiceLine.fromJson(json);
      expect(line.barcode, 'BC001');
      expect(line.classificationCode, 'CL01');

      final out = line.toJson();
      expect(out['barcode'], 'BC001');
    });
  });

  // ---------------------------------------------------------------------------
  // Deeplink
  // ---------------------------------------------------------------------------
  group('Deeplink', () {
    test('fromJson and toJson roundtrip', () {
      final json = {
        'name': 'Khan Bank',
        'description': 'Khan Bank app',
        'logo': 'https://logo.png',
        'link': 'khanbank://pay?q=123',
      };

      final dl = Deeplink.fromJson(json);
      expect(dl.name, 'Khan Bank');
      expect(dl.toJson(), json);
    });

    test('fromJson defaults to empty strings', () {
      final dl = Deeplink.fromJson(<String, dynamic>{});
      expect(dl.name, '');
      expect(dl.link, '');
    });
  });

  // ---------------------------------------------------------------------------
  // Offset
  // ---------------------------------------------------------------------------
  group('Offset', () {
    test('fromJson and toJson roundtrip', () {
      final json = {'page_number': 1, 'page_limit': 20};
      final offset = Offset.fromJson(json);
      expect(offset.pageNumber, 1);
      expect(offset.pageLimit, 20);
      expect(offset.toJson(), json);
    });
  });

  // ---------------------------------------------------------------------------
  // InvoiceResponse
  // ---------------------------------------------------------------------------
  group('InvoiceResponse', () {
    test('fromJson with urls', () {
      final json = {
        'invoice_id': 'inv-1',
        'qr_text': 'qr-text',
        'qr_image': 'qr-img',
        'qPay_shortUrl': 'https://short.url',
        'urls': [
          {
            'name': 'Bank',
            'description': 'Bank app',
            'logo': 'https://logo',
            'link': 'bank://pay',
          },
        ],
      };

      final resp = InvoiceResponse.fromJson(json);
      expect(resp.invoiceId, 'inv-1');
      expect(resp.urls, hasLength(1));
    });

    test('fromJson handles missing urls', () {
      final resp = InvoiceResponse.fromJson({'invoice_id': 'inv-2'});
      expect(resp.urls, isEmpty);
    });

    test('toJson roundtrip', () {
      const resp = InvoiceResponse(
        invoiceId: 'inv-1',
        qrText: 'qt',
        qrImage: 'qi',
        qPayShortUrl: 'qs',
        urls: [],
      );
      final json = resp.toJson();
      expect(json['invoice_id'], 'inv-1');
      expect(json['urls'], isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // CreateSimpleInvoiceRequest
  // ---------------------------------------------------------------------------
  group('CreateSimpleInvoiceRequest', () {
    test('toJson includes required fields', () {
      const req = CreateSimpleInvoiceRequest(
        invoiceCode: 'CODE',
        senderInvoiceNo: 'INV-001',
        invoiceReceiverCode: 'terminal',
        invoiceDescription: 'Test',
        amount: 5000,
        callbackUrl: 'https://cb.test',
      );

      final json = req.toJson();
      expect(json['invoice_code'], 'CODE');
      expect(json['amount'], 5000.0);
      expect(json.containsKey('sender_branch_code'), isFalse);
    });

    test('toJson includes optional senderBranchCode', () {
      const req = CreateSimpleInvoiceRequest(
        invoiceCode: 'CODE',
        senderInvoiceNo: 'INV-001',
        invoiceReceiverCode: 'terminal',
        invoiceDescription: 'Test',
        senderBranchCode: 'BR01',
        amount: 5000,
        callbackUrl: 'https://cb.test',
      );

      expect(req.toJson()['sender_branch_code'], 'BR01');
    });
  });

  // ---------------------------------------------------------------------------
  // CreateInvoiceRequest
  // ---------------------------------------------------------------------------
  group('CreateInvoiceRequest', () {
    test('toJson includes all provided fields', () {
      final req = CreateInvoiceRequest(
        invoiceCode: 'CODE',
        senderInvoiceNo: 'INV-002',
        invoiceReceiverCode: 'terminal',
        invoiceDescription: 'Full',
        amount: 10000,
        callbackUrl: 'https://cb.test',
        note: 'note',
        allowPartial: true,
        minimumAmount: 1000,
        lines: [
          const InvoiceLine(
            lineDescription: 'Item',
            lineQuantity: '1',
            lineUnitPrice: '10000',
          ),
        ],
      );

      final json = req.toJson();
      expect(json['note'], 'note');
      expect(json['allow_partial'], true);
      expect(json['minimum_amount'], 1000.0);
      expect(json['lines'], isList);
    });

    test('toJson omits null optional fields', () {
      const req = CreateInvoiceRequest(
        invoiceCode: 'CODE',
        senderInvoiceNo: 'INV-002',
        invoiceReceiverCode: 'terminal',
        invoiceDescription: 'Minimal',
        amount: 500,
        callbackUrl: 'https://cb.test',
      );

      final json = req.toJson();
      expect(json.containsKey('note'), isFalse);
      expect(json.containsKey('lines'), isFalse);
      expect(json.containsKey('allow_partial'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // PaymentCheckRequest / PaymentCheckResponse
  // ---------------------------------------------------------------------------
  group('PaymentCheckRequest', () {
    test('toJson with offset', () {
      const req = PaymentCheckRequest(
        objectType: 'INVOICE',
        objectId: 'inv-1',
        offset: Offset(pageNumber: 1, pageLimit: 10),
      );

      final json = req.toJson();
      expect(json['object_type'], 'INVOICE');
      expect(json['offset'], isA<Map>());
    });

    test('toJson without offset', () {
      const req = PaymentCheckRequest(
        objectType: 'INVOICE',
        objectId: 'inv-1',
      );

      expect(req.toJson().containsKey('offset'), isFalse);
    });
  });

  group('PaymentCheckResponse', () {
    test('fromJson parses rows', () {
      final json = {
        'count': 1,
        'paid_amount': 5000.0,
        'rows': [
          {
            'payment_id': 'pay-1',
            'payment_status': 'PAID',
            'payment_amount': '5000',
            'trx_fee': '0',
            'payment_currency': 'MNT',
            'payment_wallet': 'Khan',
            'payment_type': 'P2P',
            'card_transactions': [],
            'p2p_transactions': [],
          },
        ],
      };

      final resp = PaymentCheckResponse.fromJson(json);
      expect(resp.count, 1);
      expect(resp.paidAmount, 5000.0);
      expect(resp.rows, hasLength(1));
    });

    test('fromJson handles empty rows', () {
      final resp = PaymentCheckResponse.fromJson({'count': 0});
      expect(resp.rows, isEmpty);
      expect(resp.paidAmount, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // PaymentDetail
  // ---------------------------------------------------------------------------
  group('PaymentDetail', () {
    test('fromJson parses transactions', () {
      final json = {
        'payment_id': 'pay-1',
        'payment_status': 'PAID',
        'payment_fee': '100',
        'payment_amount': '5000',
        'payment_currency': 'MNT',
        'payment_date': '2025-01-01',
        'payment_wallet': 'Khan',
        'transaction_type': 'CARD',
        'object_type': 'INVOICE',
        'object_id': 'inv-1',
        'card_transactions': [
          {
            'card_type': 'VISA',
            'is_cross_border': false,
            'settlement_status': 'SETTLED',
            'settlement_status_date': '2025-01-02',
          },
        ],
        'p2p_transactions': [],
      };

      final detail = PaymentDetail.fromJson(json);
      expect(detail.paymentId, 'pay-1');
      expect(detail.cardTransactions, hasLength(1));
      expect(detail.cardTransactions.first.cardType, 'VISA');
      expect(detail.cardTransactions.first.isCrossBorder, false);
    });

    test('toJson roundtrip', () {
      final json = {
        'payment_id': 'pay-1',
        'payment_status': 'PAID',
        'payment_fee': '0',
        'payment_amount': '5000',
        'payment_currency': 'MNT',
        'payment_date': '2025-01-01',
        'payment_wallet': 'KB',
        'transaction_type': 'P2P',
        'object_type': 'INVOICE',
        'object_id': 'inv-1',
        'card_transactions': <Map<String, dynamic>>[],
        'p2p_transactions': <Map<String, dynamic>>[],
      };

      final roundtrip = PaymentDetail.fromJson(json).toJson();
      expect(roundtrip['payment_id'], 'pay-1');
      expect(roundtrip['payment_status'], 'PAID');
    });
  });

  // ---------------------------------------------------------------------------
  // CardTransaction
  // ---------------------------------------------------------------------------
  group('CardTransaction', () {
    test('fromJson handles all optional fields', () {
      final json = {
        'card_merchant_code': 'MC01',
        'card_terminal_code': 'TC01',
        'card_number': '****1234',
        'card_type': 'VISA',
        'is_cross_border': true,
        'amount': '5000',
        'transaction_amount': '5000',
        'currency': 'MNT',
        'transaction_currency': 'MNT',
        'date': '2025-01-01',
        'transaction_date': '2025-01-01',
        'status': 'SUCCESS',
        'transaction_status': 'APPROVED',
        'settlement_status': 'SETTLED',
        'settlement_status_date': '2025-01-02',
      };

      final ct = CardTransaction.fromJson(json);
      expect(ct.cardMerchantCode, 'MC01');
      expect(ct.isCrossBorder, true);
      expect(ct.cardNumber, '****1234');
    });
  });

  // ---------------------------------------------------------------------------
  // P2PTransaction
  // ---------------------------------------------------------------------------
  group('P2PTransaction', () {
    test('fromJson and toJson roundtrip', () {
      final json = {
        'transaction_bank_code': 'KHAN',
        'account_bank_code': 'KHAN',
        'account_bank_name': 'Khan Bank',
        'account_number': '1234567890',
        'status': 'SUCCESS',
        'amount': '5000',
        'currency': 'MNT',
        'settlement_status': 'SETTLED',
      };

      final txn = P2PTransaction.fromJson(json);
      expect(txn.transactionBankCode, 'KHAN');
      expect(txn.toJson(), json);
    });
  });

  // ---------------------------------------------------------------------------
  // PaymentListRequest / PaymentListResponse
  // ---------------------------------------------------------------------------
  group('PaymentListRequest', () {
    test('toJson produces correct structure', () {
      const req = PaymentListRequest(
        objectType: 'INVOICE',
        objectId: 'inv-1',
        startDate: '2025-01-01',
        endDate: '2025-12-31',
        offset: Offset(pageNumber: 1, pageLimit: 20),
      );

      final json = req.toJson();
      expect(json['start_date'], '2025-01-01');
      expect(json['offset']['page_limit'], 20);
    });
  });

  group('PaymentListResponse', () {
    test('fromJson parses items', () {
      final json = {
        'count': 2,
        'rows': [
          {
            'payment_id': 'p1',
            'payment_date': 'd',
            'payment_status': 's',
            'payment_fee': '0',
            'payment_amount': '100',
            'payment_currency': 'MNT',
            'payment_wallet': 'w',
            'payment_name': 'n',
            'payment_description': 'desc',
            'qr_code': 'qr',
            'paid_by': 'u',
            'object_type': 'INVOICE',
            'object_id': 'inv',
          },
        ],
      };

      final resp = PaymentListResponse.fromJson(json);
      expect(resp.count, 2);
      expect(resp.rows.first.paymentId, 'p1');
    });
  });

  // ---------------------------------------------------------------------------
  // PaymentCancelRequest / PaymentRefundRequest
  // ---------------------------------------------------------------------------
  group('PaymentCancelRequest', () {
    test('toJson includes provided fields', () {
      const req = PaymentCancelRequest(
        callbackUrl: 'https://cb.test',
        note: 'cancel',
      );
      final json = req.toJson();
      expect(json['callback_url'], 'https://cb.test');
      expect(json['note'], 'cancel');
    });

    test('toJson omits null fields', () {
      const req = PaymentCancelRequest();
      expect(req.toJson(), isEmpty);
    });
  });

  group('PaymentRefundRequest', () {
    test('toJson includes provided fields', () {
      const req = PaymentRefundRequest(note: 'refund reason');
      expect(req.toJson(), {'note': 'refund reason'});
    });
  });

  // ---------------------------------------------------------------------------
  // CreateEbarimtRequest
  // ---------------------------------------------------------------------------
  group('CreateEbarimtRequest', () {
    test('toJson with all fields', () {
      const req = CreateEbarimtRequest(
        paymentId: 'pay-1',
        ebarimtReceiverType: 'INDIVIDUAL',
        ebarimtReceiver: '99001122',
        districtCode: 'UB01',
        classificationCode: 'CL01',
      );

      final json = req.toJson();
      expect(json['payment_id'], 'pay-1');
      expect(json['district_code'], 'UB01');
    });

    test('toJson omits null optional fields', () {
      const req = CreateEbarimtRequest(
        paymentId: 'pay-1',
        ebarimtReceiverType: 'INDIVIDUAL',
      );

      final json = req.toJson();
      expect(json.containsKey('ebarimt_receiver'), isFalse);
      expect(json.containsKey('district_code'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // EbarimtResponse
  // ---------------------------------------------------------------------------
  group('EbarimtResponse', () {
    test('fromJson parses all required fields', () {
      final json = {
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
        'ebarimt_lottery': 'LOT123',
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

      final resp = EbarimtResponse.fromJson(json);
      expect(resp.id, 'eb-1');
      expect(resp.ebarimtLottery, 'LOT123');
      expect(resp.status, true);
      expect(resp.barimtItems, isNull);
    });

    test('fromJson with nested items and histories', () {
      final json = {
        'id': 'eb-2',
        'ebarimt_by': 'MERCHANT',
        'g_wallet_id': 'w',
        'g_wallet_customer_id': 'c',
        'ebarimt_receiver_type': 'INDIVIDUAL',
        'ebarimt_receiver': '99',
        'ebarimt_district_code': 'UB',
        'ebarimt_bill_type': 'B2C',
        'g_merchant_id': 'm',
        'merchant_branch_code': 'br',
        'merchant_register_no': 'REG',
        'g_payment_id': 'pay',
        'paid_by': 'u',
        'object_type': 'INVOICE',
        'object_id': 'inv',
        'amount': '1000',
        'vat_amount': '100',
        'city_tax_amount': '10',
        'ebarimt_qr_data': 'qr',
        'ebarimt_lottery': 'L',
        'barimt_status': 'CREATED',
        'barimt_status_date': '2025-01-01',
        'ebarimt_receiver_phone': '99',
        'tax_type': 'VAT',
        'created_by': 'sys',
        'created_date': '2025-01-01',
        'updated_by': 'sys',
        'updated_date': '2025-01-01',
        'status': true,
        'barimt_items': [
          {
            'id': 'item-1',
            'barimt_id': 'eb-2',
            'tax_product_code': 'TP01',
            'name': 'Widget',
            'unit_price': '1000',
            'quantity': '1',
            'amount': '1000',
            'city_tax_amount': '10',
            'vat_amount': '100',
            'created_by': 'sys',
            'created_date': '2025-01-01',
            'updated_by': 'sys',
            'updated_date': '2025-01-01',
            'status': true,
          },
        ],
        'barimt_histories': [
          {
            'id': 'hist-1',
            'barimt_id': 'eb-2',
            'ebarimt_receiver_type': 'INDIVIDUAL',
            'ebarimt_receiver': '99',
            'ebarimt_bill_id': 'bill-1',
            'ebarimt_date': '2025-01-01',
            'ebarimt_mac_address': 'AA:BB:CC',
            'ebarimt_internal_code': 'IC01',
            'ebarimt_bill_type': 'B2C',
            'ebarimt_qr_data': 'qr',
            'ebarimt_lottery': 'L',
            'barimt_status': 'CREATED',
            'barimt_status_date': '2025-01-01',
            'ebarimt_receiver_phone': '99',
            'tax_type': 'VAT',
            'created_by': 'sys',
            'created_date': '2025-01-01',
            'updated_by': 'sys',
            'updated_date': '2025-01-01',
            'status': true,
          },
        ],
      };

      final resp = EbarimtResponse.fromJson(json);
      expect(resp.barimtItems, hasLength(1));
      expect(resp.barimtItems!.first.name, 'Widget');
      expect(resp.barimtHistories, hasLength(1));
      expect(resp.barimtHistories!.first.ebarimtMacAddress, 'AA:BB:CC');
    });
  });

  // ---------------------------------------------------------------------------
  // EbarimtItem
  // ---------------------------------------------------------------------------
  group('EbarimtItem', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'item-1',
        'barimt_id': 'eb-1',
        'merchant_product_code': 'MP01',
        'tax_product_code': 'TP01',
        'bar_code': 'BC01',
        'name': 'Widget',
        'unit_price': '1000',
        'quantity': '2',
        'amount': '2000',
        'city_tax_amount': '20',
        'vat_amount': '200',
        'note': 'item note',
        'created_by': 'sys',
        'created_date': '2025-01-01',
        'updated_by': 'sys',
        'updated_date': '2025-01-01',
        'status': true,
      };

      final item = EbarimtItem.fromJson(json);
      expect(item.merchantProductCode, 'MP01');
      expect(item.barCode, 'BC01');
      expect(item.quantity, '2');
    });
  });

  // ---------------------------------------------------------------------------
  // EbarimtHistory
  // ---------------------------------------------------------------------------
  group('EbarimtHistory', () {
    test('fromJson handles optional fields', () {
      final json = {
        'id': 'hist-1',
        'barimt_id': 'eb-1',
        'ebarimt_receiver_type': 'COMPANY',
        'ebarimt_receiver': 'REG123',
        'ebarimt_register_no': 'REG123',
        'ebarimt_bill_id': 'bill-1',
        'ebarimt_date': '2025-01-01',
        'ebarimt_mac_address': 'AA:BB',
        'ebarimt_internal_code': 'IC',
        'ebarimt_bill_type': 'B2B',
        'ebarimt_qr_data': 'qr',
        'ebarimt_lottery': 'LOT',
        'ebarimt_lottery_msg': 'Congratulations',
        'ebarimt_error_code': null,
        'ebarimt_error_msg': null,
        'barimt_status': 'CREATED',
        'barimt_status_date': '2025-01-01',
        'ebarimt_receiver_phone': '88',
        'tax_type': 'VAT',
        'created_by': 'sys',
        'created_date': '2025-01-01',
        'updated_by': 'sys',
        'updated_date': '2025-01-01',
        'status': true,
      };

      final hist = EbarimtHistory.fromJson(json);
      expect(hist.ebarimtRegisterNo, 'REG123');
      expect(hist.ebarimtLotteryMsg, 'Congratulations');
      expect(hist.ebarimtErrorCode, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // CreateEbarimtInvoiceRequest
  // ---------------------------------------------------------------------------
  group('CreateEbarimtInvoiceRequest', () {
    test('toJson includes lines and tax info', () {
      final req = CreateEbarimtInvoiceRequest(
        invoiceCode: 'CODE',
        senderInvoiceNo: 'INV-001',
        invoiceReceiverCode: 'terminal',
        invoiceDescription: 'Tax invoice',
        taxType: 'VAT',
        districtCode: 'UB01',
        callbackUrl: 'https://cb.test',
        lines: [
          const EbarimtInvoiceLine(
            lineDescription: 'Service',
            lineQuantity: '1',
            lineUnitPrice: '10000',
          ),
        ],
      );

      final json = req.toJson();
      expect(json['tax_type'], 'VAT');
      expect(json['district_code'], 'UB01');
      expect(json['lines'], hasLength(1));
    });
  });
}
