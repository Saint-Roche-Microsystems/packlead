import 'package:dartz/dartz.dart';
import 'package:packlead/core/errors/auth_exceptions.dart';
import 'package:packlead/core/models/user.dart';
import 'package:packlead/features/auth/data/datasources/auth_datasource.dart';
import 'package:packlead/features/auth/data/repositories/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImp(this._dataSource);

  @override
  Future<Either<String, User>> login(String email, String password) async {
    try {
      final user = await _dataSource.login(email, password);
      return Right(user);
    } on AuthException catch(e) {
      return Left(e.message);
    } catch (e) {
      return const Left('Ocurrió un error inesperado');
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