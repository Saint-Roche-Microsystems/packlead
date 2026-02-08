import 'package:packlead/core/models/user.dart';
import 'package:packlead/features/auth/data/datasources/auth_datasource.dart';
import 'package:packlead/features/auth/data/repositories/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImp(this._dataSource);

  @override
  Future<User> login(String email, String password) async {
    try{
      return await _dataSource.login(email, password);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try{
      return await _dataSource.logout();
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return await _dataSource.getCurrentUser();
  }
}