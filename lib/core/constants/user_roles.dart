enum UserRole {
  admin,
  dispatcher,
  none,
}

extension UserRoleExtension on UserRole {
  String toJson() => name;

  static UserRole fromJson(String value) {
    return UserRole.values.firstWhere(
          (e) => e.name == value,
      orElse: () => UserRole.none,
    );
  }
}