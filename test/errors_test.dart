import 'package:qpay/qpay.dart';
import 'package:test/test.dart';

void main() {
  group('QPayException', () {
    test('constructor stores all fields', () {
      const ex = QPayException(
        statusCode: 400,
        code: 'INVOICE_NOTFOUND',
        message: 'Invoice not found',
        rawBody: '{"error":"INVOICE_NOTFOUND"}',
      );

      expect(ex.statusCode, 400);
      expect(ex.code, 'INVOICE_NOTFOUND');
      expect(ex.message, 'Invoice not found');
      expect(ex.rawBody, '{"error":"INVOICE_NOTFOUND"}');
    });

    test('rawBody defaults to empty string', () {
      const ex = QPayException(
        statusCode: 500,
        code: 'ERROR',
        message: 'msg',
      );
      expect(ex.rawBody, '');
    });

    test('toString includes code, message, and status', () {
      const ex = QPayException(
        statusCode: 404,
        code: 'PAYMENT_NOTFOUND',
        message: 'Payment not found',
      );
      final str = ex.toString();
      expect(str, contains('PAYMENT_NOTFOUND'));
      expect(str, contains('Payment not found'));
      expect(str, contains('404'));
    });

    test('fromJson parses error and message fields', () {
      final json = {
        'error': 'AUTHENTICATION_FAILED',
        'message': 'Invalid credentials',
      };

      final ex = QPayException.fromJson(
        json,
        statusCode: 401,
        rawBody: '{"error":"AUTHENTICATION_FAILED"}',
      );

      expect(ex.statusCode, 401);
      expect(ex.code, 'AUTHENTICATION_FAILED');
      expect(ex.message, 'Invalid credentials');
      expect(ex.rawBody, '{"error":"AUTHENTICATION_FAILED"}');
    });

    test('fromJson handles missing fields gracefully', () {
      final ex = QPayException.fromJson(
        <String, dynamic>{},
        statusCode: 500,
      );

      expect(ex.code, '');
      expect(ex.message, '');
      expect(ex.rawBody, '');
    });

    test('implements Exception', () {
      const ex = QPayException(
        statusCode: 400,
        code: 'ERROR',
        message: 'test',
      );
      expect(ex, isA<Exception>());
    });
  });

  group('Error code constants', () {
    test('authenticationFailed', () {
      expect(QPayException.authenticationFailed, 'AUTHENTICATION_FAILED');
    });

    test('invoiceNotFound', () {
      expect(QPayException.invoiceNotFound, 'INVOICE_NOTFOUND');
    });

    test('invoicePaid', () {
      expect(QPayException.invoicePaid, 'INVOICE_PAID');
    });

    test('invoiceAlreadyCanceled', () {
      expect(QPayException.invoiceAlreadyCanceled, 'INVOICE_ALREADY_CANCELED');
    });

    test('invoiceCodeInvalid', () {
      expect(QPayException.invoiceCodeInvalid, 'INVOICE_CODE_INVALID');
    });

    test('paymentNotFound', () {
      expect(QPayException.paymentNotFound, 'PAYMENT_NOTFOUND');
    });

    test('paymentAlreadyCanceled', () {
      expect(QPayException.paymentAlreadyCanceled, 'PAYMENT_ALREADY_CANCELED');
    });

    test('paymentNotPaid', () {
      expect(QPayException.paymentNotPaid, 'PAYMENT_NOT_PAID');
    });

    test('permissionDenied', () {
      expect(QPayException.permissionDenied, 'PERMISSION_DENIED');
    });

    test('invalidAmount', () {
      expect(QPayException.invalidAmount, 'INVALID_AMOUNT');
    });

    test('merchantNotFound', () {
      expect(QPayException.merchantNotFound, 'MERCHANT_NOTFOUND');
    });

    test('merchantInactive', () {
      expect(QPayException.merchantInactive, 'MERCHANT_INACTIVE');
    });

    test('noCredentials', () {
      expect(QPayException.noCredentials, 'NO_CREDENDIALS');
    });

    test('ebarimtCancelNotSupported', () {
      expect(
          QPayException.ebarimtCancelNotSupported, 'EBARIMT_CANCEL_NOTSUPPERDED');
    });

    test('ebarimtNotRegistered', () {
      expect(QPayException.ebarimtNotRegistered, 'EBARIMT_NOT_REGISTERED');
    });

    test('minAmountErr', () {
      expect(QPayException.minAmountErr, 'MIN_AMOUNT_ERR');
    });

    test('maxAmountErr', () {
      expect(QPayException.maxAmountErr, 'MAX_AMOUNT_ERR');
    });

    test('transactionRequired', () {
      expect(QPayException.transactionRequired, 'TRANSACTION_REQUIRED');
    });

    test('invoiceLineRequired', () {
      expect(QPayException.invoiceLineRequired, 'INVOICE_LINE_REQUIRED');
    });
  });
}
