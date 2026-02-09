import 'package:packlead/core/models/user.dart';
import 'package:packlead/features/auth/data/datasources/auth_datasource.dart';
import 'package:packlead/mocks/users_mock_data.dart';


class AuthMockDataSource implements AuthDataSource {
  final _users = UsersMockData().users;
  User? _currentUser;

  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere(
            (user) => user.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final user = getUserByEmail(email);

    if (user == null || user.password != password) {
      throw Exception('Correo o contraseña incorrectos');
    }

    _currentUser = user;

    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }
}