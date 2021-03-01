class LoginResponse {
  final int id;
  final String username;
  final String email;
  final String accessToken;
  final String tokenType;

  LoginResponse(this.id, this.username, this.email,
      this.accessToken, this.tokenType);

  LoginResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        accessToken = json['accessToken'],
        tokenType = json['tokenType'];
}
