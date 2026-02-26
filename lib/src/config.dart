import 'dart:io' show Platform;

/// Configuration for the QPay V2 API client.
class QPayConfig {
  /// QPay API base URL (e.g. "https://merchant.qpay.mn").
  final String baseUrl;

  /// QPay merchant username for authentication.
  final String username;

  /// QPay merchant password for authentication.
  final String password;

  /// Default invoice code for creating invoices.
  final String invoiceCode;

  /// Callback URL for payment notifications.
  final String callbackUrl;

  const QPayConfig({
    required this.baseUrl,
    required this.username,
    required this.password,
    required this.invoiceCode,
    required this.callbackUrl,
  });

  /// Creates a [QPayConfig] from environment variables.
  ///
  /// Reads the following environment variables:
  /// - `QPAY_BASE_URL`
  /// - `QPAY_USERNAME`
  /// - `QPAY_PASSWORD`
  /// - `QPAY_INVOICE_CODE`
  /// - `QPAY_CALLBACK_URL`
  ///
  /// Throws [ArgumentError] if any required variable is not set.
  factory QPayConfig.fromEnvironment() {
    final env = Platform.environment;

    final requiredVars = {
      'QPAY_BASE_URL': env['QPAY_BASE_URL'],
      'QPAY_USERNAME': env['QPAY_USERNAME'],
      'QPAY_PASSWORD': env['QPAY_PASSWORD'],
      'QPAY_INVOICE_CODE': env['QPAY_INVOICE_CODE'],
      'QPAY_CALLBACK_URL': env['QPAY_CALLBACK_URL'],
    };

    for (final entry in requiredVars.entries) {
      if (entry.value == null || entry.value!.isEmpty) {
        throw ArgumentError(
          'Required environment variable ${entry.key} is not set',
        );
      }
    }

    return QPayConfig(
      baseUrl: requiredVars['QPAY_BASE_URL']!,
      username: requiredVars['QPAY_USERNAME']!,
      password: requiredVars['QPAY_PASSWORD']!,
      invoiceCode: requiredVars['QPAY_INVOICE_CODE']!,
      callbackUrl: requiredVars['QPAY_CALLBACK_URL']!,
    );
  }
}
