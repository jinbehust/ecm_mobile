class User {
  String username;
  String password;

  User(this.username, this.password);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = username;
    data['password'] = password;
    return data;
  }

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'] as String;
    password = json['password'] as String;
  }
}
