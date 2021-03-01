class LoginRequest {
  final String username;
  final String password;

  LoginRequest(this.username, this.password);

  LoginRequest.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'password': password,
      };
}