import 'package:qpay/qpay.dart';
import 'package:test/test.dart';

void main() {
  group('QPayConfig', () {
    test('constructor stores all fields correctly', () {
      const config = QPayConfig(
        baseUrl: 'https://merchant.qpay.mn',
        username: 'testuser',
        password: 'testpass',
        invoiceCode: 'INV_CODE',
        callbackUrl: 'https://example.com/callback',
      );

      expect(config.baseUrl, 'https://merchant.qpay.mn');
      expect(config.username, 'testuser');
      expect(config.password, 'testpass');
      expect(config.invoiceCode, 'INV_CODE');
      expect(config.callbackUrl, 'https://example.com/callback');
    });

    test('supports const constructor', () {
      // Verify that const constructor compiles and two identical instances
      // are the same object.
      const a = QPayConfig(
        baseUrl: 'https://a.test',
        username: 'u',
        password: 'p',
        invoiceCode: 'c',
        callbackUrl: 'cb',
      );
      const b = QPayConfig(
        baseUrl: 'https://a.test',
        username: 'u',
        password: 'p',
        invoiceCode: 'c',
        callbackUrl: 'cb',
      );
      expect(identical(a, b), isTrue);
    });
  });

  // Note: QPayConfig.fromEnvironment() reads Platform.environment which
  // cannot be easily overridden in unit tests. It is tested below by
  // verifying that calling it without the expected variables throws an
  // ArgumentError.
  group('QPayConfig.fromEnvironment', () {
    test('throws ArgumentError when environment variables are not set', () {
      // In a typical test environment, the QPAY_* variables are not set,
      // so this should throw an ArgumentError.
      expect(
        () => QPayConfig.fromEnvironment(),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('QPAY_BASE_URL'),
        )),
      );
    });
  });
}
