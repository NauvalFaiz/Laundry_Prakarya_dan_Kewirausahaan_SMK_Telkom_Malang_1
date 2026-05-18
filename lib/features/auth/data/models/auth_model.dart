class AuthModel {
  final UserModel? user;
  final String? token;
  final String? message;
  final bool success;

  AuthModel({this.user, this.token, this.message, this.success = true});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      token: json['token'],
      message: json['message'],
      success: json['success'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'token': token,
      'message': message,
      'success': success,
    };
  }
}

class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? avatar;
  final String? provider;
  final int? points;
  final int? level;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.avatar,
    this.provider,
    this.points,
    this.level,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      avatar: json['avatar_url'] ?? json['avatar'],
      provider: json['provider'],
      points: json['points'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'avatar': avatar,
      'provider': provider,
      'points': points,
      'level': level,
    };
  }
}
