/// Exception thrown when a QPay API request fails.
class QPayException implements Exception {
  /// HTTP status code of the response.
  final int statusCode;

  /// QPay error code (e.g. "INVOICE_NOTFOUND").
  final String code;

  /// Human-readable error message.
  final String message;

  /// Raw response body for debugging.
  final String rawBody;

  const QPayException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.rawBody = '',
  });

  /// Creates a [QPayException] from a JSON map parsed from the API response.
  factory QPayException.fromJson(
    Map<String, dynamic> json, {
    required int statusCode,
    String rawBody = '',
  }) {
    return QPayException(
      statusCode: statusCode,
      code: json['error'] as String? ?? '',
      message: json['message'] as String? ?? '',
      rawBody: rawBody,
    );
  }

  @override
  String toString() => 'QPayException: $code - $message (status $statusCode)';

  // ---------------------------------------------------------------------------
  // Error code constants
  // ---------------------------------------------------------------------------

  static const String accountBankDuplicated = 'ACCOUNT_BANK_DUPLICATED';
  static const String accountSelectionInvalid = 'ACCOUNT_SELECTION_INVALID';
  static const String authenticationFailed = 'AUTHENTICATION_FAILED';
  static const String bankAccountNotFound = 'BANK_ACCOUNT_NOTFOUND';
  static const String bankMccAlreadyAdded = 'BANK_MCC_ALREADY_ADDED';
  static const String bankMccNotFound = 'BANK_MCC_NOT_FOUND';
  static const String cardTerminalNotFound = 'CARD_TERMINAL_NOTFOUND';
  static const String clientNotFound = 'CLIENT_NOTFOUND';
  static const String clientUsernameDuplicated = 'CLIENT_USERNAME_DUPLICATED';
  static const String customerDuplicate = 'CUSTOMER_DUPLICATE';
  static const String customerNotFound = 'CUSTOMER_NOTFOUND';
  static const String customerRegisterInvalid = 'CUSTOMER_REGISTER_INVALID';
  static const String ebarimtCancelNotSupported = 'EBARIMT_CANCEL_NOTSUPPERDED';
  static const String ebarimtNotRegistered = 'EBARIMT_NOT_REGISTERED';
  static const String ebarimtQrCodeInvalid = 'EBARIMT_QR_CODE_INVALID';
  static const String informNotFound = 'INFORM_NOTFOUND';
  static const String inputCodeRegistered = 'INPUT_CODE_REGISTERED';
  static const String inputNotFound = 'INPUT_NOTFOUND';
  static const String invalidAmount = 'INVALID_AMOUNT';
  static const String invalidObjectType = 'INVALID_OBJECT_TYPE';
  static const String invoiceAlreadyCanceled = 'INVOICE_ALREADY_CANCELED';
  static const String invoiceCodeInvalid = 'INVOICE_CODE_INVALID';
  static const String invoiceCodeRegistered = 'INVOICE_CODE_REGISTERED';
  static const String invoiceLineRequired = 'INVOICE_LINE_REQUIRED';
  static const String invoiceNotFound = 'INVOICE_NOTFOUND';
  static const String invoicePaid = 'INVOICE_PAID';
  static const String invoiceReceiverDataAddressRequired =
      'INVOICE_RECEIVER_DATA_ADDRESS_REQUIRED';
  static const String invoiceReceiverDataEmailRequired =
      'INVOICE_RECEIVER_DATA_EMAIL_REQUIRED';
  static const String invoiceReceiverDataPhoneRequired =
      'INVOICE_RECEIVER_DATA_PHONE_REQUIRED';
  static const String invoiceReceiverDataRequired =
      'INVOICE_RECEIVER_DATA_REQUIRED';
  static const String maxAmountErr = 'MAX_AMOUNT_ERR';
  static const String mccNotFound = 'MCC_NOTFOUND';
  static const String merchantAlreadyRegistered = 'MERCHANT_ALREADY_REGISTERED';
  static const String merchantInactive = 'MERCHANT_INACTIVE';
  static const String merchantNotFound = 'MERCHANT_NOTFOUND';
  static const String minAmountErr = 'MIN_AMOUNT_ERR';
  static const String noCredentials = 'NO_CREDENDIALS';
  static const String objectDataError = 'OBJECT_DATA_ERROR';
  static const String p2pTerminalNotFound = 'P2P_TERMINAL_NOTFOUND';
  static const String paymentAlreadyCanceled = 'PAYMENT_ALREADY_CANCELED';
  static const String paymentNotPaid = 'PAYMENT_NOT_PAID';
  static const String paymentNotFound = 'PAYMENT_NOTFOUND';
  static const String permissionDenied = 'PERMISSION_DENIED';
  static const String qrAccountInactive = 'QRACCOUNT_INACTIVE';
  static const String qrAccountNotFound = 'QRACCOUNT_NOTFOUND';
  static const String qrCodeNotFound = 'QRCODE_NOTFOUND';
  static const String qrCodeUsed = 'QRCODE_USED';
  static const String senderBranchDataRequired = 'SENDER_BRANCH_DATA_REQUIRED';
  static const String taxLineRequired = 'TAX_LINE_REQUIRED';
  static const String taxProductCodeRequired = 'TAX_PRODUCT_CODE_REQUIRED';
  static const String transactionNotApproved = 'TRANSACTION_NOT_APPROVED';
  static const String transactionRequired = 'TRANSACTION_REQUIRED';
}
