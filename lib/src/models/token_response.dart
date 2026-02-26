/// Response from QPay authentication endpoints (`/v2/auth/token` and `/v2/auth/refresh`).
class TokenResponse {
  final String tokenType;
  final int refreshExpiresIn;
  final String refreshToken;
  final String accessToken;
  final int expiresIn;
  final String scope;
  final String notBeforePolicy;
  final String sessionState;

  const TokenResponse({
    required this.tokenType,
    required this.refreshExpiresIn,
    required this.refreshToken,
    required this.accessToken,
    required this.expiresIn,
    required this.scope,
    required this.notBeforePolicy,
    required this.sessionState,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      tokenType: json['token_type'] as String? ?? '',
      refreshExpiresIn: json['refresh_expires_in'] as int? ?? 0,
      refreshToken: json['refresh_token'] as String? ?? '',
      accessToken: json['access_token'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
      scope: json['scope'] as String? ?? '',
      notBeforePolicy: json['not-before-policy'] as String? ?? '',
      sessionState: json['session_state'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token_type': tokenType,
      'refresh_expires_in': refreshExpiresIn,
      'refresh_token': refreshToken,
      'access_token': accessToken,
      'expires_in': expiresIn,
      'scope': scope,
      'not-before-policy': notBeforePolicy,
      'session_state': sessionState,
    };
  }
}
