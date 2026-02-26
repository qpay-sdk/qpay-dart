import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config.dart';
import 'errors.dart';
import 'models/ebarimt_models.dart';
import 'models/invoice_models.dart';
import 'models/payment_models.dart';
import 'models/token_response.dart';

/// Buffer in seconds before token expiry to trigger refresh.
const int _tokenBufferSeconds = 30;

/// QPay V2 API client with automatic token management.
///
/// Creates invoices, checks/lists payments, manages ebarimt receipts,
/// and handles authentication transparently.
///
/// ```dart
/// final client = QPayClient(QPayConfig(
///   baseUrl: 'https://merchant.qpay.mn',
///   username: 'USERNAME',
///   password: 'PASSWORD',
///   invoiceCode: 'CODE',
///   callbackUrl: 'https://example.com/callback',
/// ));
///
/// final invoice = await client.createSimpleInvoice(CreateSimpleInvoiceRequest(
///   invoiceCode: 'CODE',
///   senderInvoiceNo: 'INV-001',
///   invoiceReceiverCode: 'terminal',
///   invoiceDescription: 'Test payment',
///   amount: 1000,
///   callbackUrl: 'https://example.com/callback',
/// ));
/// ```
class QPayClient {
  final QPayConfig _config;
  final http.Client _httpClient;
  final bool _ownsHttpClient;

  String _accessToken = '';
  String _refreshToken = '';
  int _expiresAt = 0;
  int _refreshExpiresAt = 0;

  /// Creates a new [QPayClient] with the given [config].
  ///
  /// An optional [httpClient] can be provided for testing or custom
  /// configurations. If not provided, a default [http.Client] is created
  /// and will be closed when [close] is called.
  QPayClient(QPayConfig config, {http.Client? httpClient})
      : _config = config,
        _httpClient = httpClient ?? http.Client(),
        _ownsHttpClient = httpClient == null;

  /// Closes the underlying HTTP client.
  ///
  /// Only closes the client if it was created internally (not passed in).
  void close() {
    if (_ownsHttpClient) {
      _httpClient.close();
    }
  }

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  /// Authenticates with QPay using Basic Auth and returns a new token pair.
  ///
  /// POST /v2/auth/token
  Future<TokenResponse> getToken() async {
    final token = await _getTokenRequest();
    _storeToken(token);
    return token;
  }

  /// Uses the current refresh token to obtain a new access token.
  ///
  /// POST /v2/auth/refresh
  Future<TokenResponse> refreshToken() async {
    final token = await _doRefreshTokenHttp(_refreshToken);
    _storeToken(token);
    return token;
  }

  // ---------------------------------------------------------------------------
  // Invoice
  // ---------------------------------------------------------------------------

  /// Creates a detailed invoice with full options.
  ///
  /// POST /v2/invoice
  Future<InvoiceResponse> createInvoice(CreateInvoiceRequest request) async {
    final json = await _doRequest('POST', '/v2/invoice', body: request.toJson());
    return InvoiceResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Creates a simple invoice with minimal fields.
  ///
  /// POST /v2/invoice
  Future<InvoiceResponse> createSimpleInvoice(
      CreateSimpleInvoiceRequest request) async {
    final json = await _doRequest('POST', '/v2/invoice', body: request.toJson());
    return InvoiceResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Creates an invoice with ebarimt (tax) information.
  ///
  /// POST /v2/invoice
  Future<InvoiceResponse> createEbarimtInvoice(
      CreateEbarimtInvoiceRequest request) async {
    final json = await _doRequest('POST', '/v2/invoice', body: request.toJson());
    return InvoiceResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Cancels an existing invoice by ID.
  ///
  /// DELETE /v2/invoice/{id}
  Future<void> cancelInvoice(String invoiceId) async {
    await _doRequest('DELETE', '/v2/invoice/$invoiceId');
  }

  // ---------------------------------------------------------------------------
  // Payment
  // ---------------------------------------------------------------------------

  /// Retrieves payment details by payment ID.
  ///
  /// GET /v2/payment/{id}
  Future<PaymentDetail> getPayment(String paymentId) async {
    final json = await _doRequest('GET', '/v2/payment/$paymentId');
    return PaymentDetail.fromJson(json as Map<String, dynamic>);
  }

  /// Checks if a payment has been made for an invoice.
  ///
  /// POST /v2/payment/check
  Future<PaymentCheckResponse> checkPayment(
      PaymentCheckRequest request) async {
    final json =
        await _doRequest('POST', '/v2/payment/check', body: request.toJson());
    return PaymentCheckResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Returns a list of payments matching the given criteria.
  ///
  /// POST /v2/payment/list
  Future<PaymentListResponse> listPayments(
      PaymentListRequest request) async {
    final json =
        await _doRequest('POST', '/v2/payment/list', body: request.toJson());
    return PaymentListResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Cancels a payment (card transactions only).
  ///
  /// DELETE /v2/payment/cancel/{id}
  Future<void> cancelPayment(
      String paymentId, PaymentCancelRequest request) async {
    await _doRequest('DELETE', '/v2/payment/cancel/$paymentId',
        body: request.toJson());
  }

  /// Refunds a payment (card transactions only).
  ///
  /// DELETE /v2/payment/refund/{id}
  Future<void> refundPayment(
      String paymentId, PaymentRefundRequest request) async {
    await _doRequest('DELETE', '/v2/payment/refund/$paymentId',
        body: request.toJson());
  }

  // ---------------------------------------------------------------------------
  // Ebarimt
  // ---------------------------------------------------------------------------

  /// Creates an ebarimt (electronic tax receipt) for a payment.
  ///
  /// POST /v2/ebarimt_v3/create
  Future<EbarimtResponse> createEbarimt(CreateEbarimtRequest request) async {
    final json = await _doRequest('POST', '/v2/ebarimt_v3/create',
        body: request.toJson());
    return EbarimtResponse.fromJson(json as Map<String, dynamic>);
  }

  /// Cancels an ebarimt by payment ID.
  ///
  /// DELETE /v2/ebarimt_v3/{id}
  Future<EbarimtResponse> cancelEbarimt(String paymentId) async {
    final json = await _doRequest('DELETE', '/v2/ebarimt_v3/$paymentId');
    return EbarimtResponse.fromJson(json as Map<String, dynamic>);
  }

  // ---------------------------------------------------------------------------
  // Internal: Token management
  // ---------------------------------------------------------------------------

  Future<void> _ensureToken() async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Access token still valid
    if (_accessToken.isNotEmpty && now < _expiresAt - _tokenBufferSeconds) {
      return;
    }

    // Determine strategy: refresh or full auth
    final canRefresh =
        _refreshToken.isNotEmpty && now < _refreshExpiresAt - _tokenBufferSeconds;

    if (canRefresh) {
      try {
        final token = await _doRefreshTokenHttp(_refreshToken);
        _storeToken(token);
        return;
      } catch (_) {
        // Refresh failed, fall through to get new token
      }
    }

    // Both expired or no tokens, get new token
    try {
      final token = await _getTokenRequest();
      _storeToken(token);
    } catch (e) {
      throw QPayException(
        statusCode: 0,
        code: 'TOKEN_ERROR',
        message: 'Failed to get token: $e',
      );
    }
  }

  Future<TokenResponse> _doRefreshTokenHttp(String refreshTok) async {
    final url = Uri.parse('${_config.baseUrl}/v2/auth/refresh');
    final response = await _httpClient.post(
      url,
      headers: {'Authorization': 'Bearer $refreshTok'},
    );

    final respBody = response.body;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      _throwQPayException(response.statusCode, respBody);
    }

    return TokenResponse.fromJson(
        jsonDecode(respBody) as Map<String, dynamic>);
  }

  Future<TokenResponse> _getTokenRequest() async {
    final url = Uri.parse('${_config.baseUrl}/v2/auth/token');
    final credentials =
        base64Encode(utf8.encode('${_config.username}:${_config.password}'));
    final response = await _httpClient.post(
      url,
      headers: {'Authorization': 'Basic $credentials'},
    );

    final respBody = response.body;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      _throwQPayException(response.statusCode, respBody);
    }

    return TokenResponse.fromJson(
        jsonDecode(respBody) as Map<String, dynamic>);
  }

  void _storeToken(TokenResponse token) {
    _accessToken = token.accessToken;
    _refreshToken = token.refreshToken;
    _expiresAt = token.expiresIn;
    _refreshExpiresAt = token.refreshExpiresIn;
  }

  // ---------------------------------------------------------------------------
  // Internal: HTTP
  // ---------------------------------------------------------------------------

  /// Performs an authenticated request. Returns the decoded JSON body or null.
  Future<dynamic> _doRequest(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    await _ensureToken();

    final url = Uri.parse('${_config.baseUrl}$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };

    final http.Response response;

    switch (method) {
      case 'GET':
        response = await _httpClient.get(url, headers: headers);
        break;
      case 'POST':
        response = await _httpClient.post(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'DELETE':
        response = await _httpClient.delete(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }

    final respBody = response.body;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      _throwQPayException(response.statusCode, respBody);
    }

    if (respBody.isNotEmpty) {
      return jsonDecode(respBody);
    }

    return null;
  }

  Never _throwQPayException(int statusCode, String body) {
    String code = '';
    String message = '';

    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      code = json['error'] as String? ?? '';
      message = json['message'] as String? ?? '';
    } catch (_) {
      // Body is not valid JSON
    }

    if (code.isEmpty) {
      code = _httpStatusText(statusCode);
    }
    if (message.isEmpty) {
      message = body;
    }

    throw QPayException(
      statusCode: statusCode,
      code: code,
      message: message,
      rawBody: body,
    );
  }

  static String _httpStatusText(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 405:
        return 'Method Not Allowed';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      case 429:
        return 'Too Many Requests';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      default:
        return 'HTTP $statusCode';
    }
  }
}
