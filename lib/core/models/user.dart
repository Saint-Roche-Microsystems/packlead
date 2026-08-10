import 'package:packlead/core/constants/user_roles.dart';

class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final UserRole role;

  const User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  User copyWith({
    String? id,
    String? email,
    String? password,
    UserRole? role,
    String? name,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      role: UserRoleExtension.fromJson(json['role'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'role': role.name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          role == other.role;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ name.hashCode ^ role.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: ${role.name})';
  }
}
