class AuthModel {
  final User? user;
  final String? token;
  final String? message;

  AuthModel({this.user, this.token, this.message});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'token': token,
      'message': message,
    };
  }
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;

  User({this.id, this.name, this.email, this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
