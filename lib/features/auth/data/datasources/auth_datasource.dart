import 'package:packlead/core/models/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<void> logout();
}