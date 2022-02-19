class OauthAccessToken {
  final String? accessToken;
  final String? refreshToken;

  const OauthAccessToken({
    this.accessToken,
    this.refreshToken,
  });

  factory OauthAccessToken.fromJson(Map<String, String?> json) =>
      OauthAccessToken(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
      );

  Map<String, dynamic> toJson() => <String, String?>{
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
}
