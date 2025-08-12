class LogoutParams {
  final String refreshToken;
  final String accessToken;

  LogoutParams({required this.refreshToken, required this.accessToken});

  Map<String, dynamic> toJson() => {
        'refreshToken': refreshToken,
        'accessToken': accessToken,
      };
}
