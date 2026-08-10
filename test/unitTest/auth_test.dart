import 'package:flutter_test/flutter_test.dart';
import 'package:packlead/core/errors/auth_exceptions.dart';
import 'package:packlead/core/models/user.dart';
import 'package:packlead/features/auth/data/datasources/auth_mock_datasource.dart';

void main() {
  late AuthMockDataSource dataSource;

  setUp(() {
    dataSource = AuthMockDataSource();
  });

  group('AuthMockDataSource - login', () {
    test('Debe hacer login correctamente con credenciales válidas', () async {
      // Arrange
      final email = dataSource
          .getUserByEmail(
            dataSource.getUserByEmail('admin@packlead.com')!.email,
          )!
          .email;

      final user = dataSource.getUserByEmail(email)!;

      // Act
      final result = await dataSource.login(user.email, user.password);

      // Assert
      expect(result, isA<User>());
      expect(result.email, user.email);
      expect(result.name, user.name);
      expect(result.role, user.role);
    });

    test(
      'Debe lanzar InvalidCredentialsException si el email no existe',
      () async {
        expect(
          () => dataSource.login('noexiste@test.com', '123456'),
          throwsA(isA<InvalidCredentialsException>()),
        );
      },
    );

    test(
      'Debe lanzar InvalidCredentialsException si el password es incorrecto',
      () async {
        // Arrange
        final user = dataSource.getUserByEmail('admin@packlead.com');

        if (user == null) {
          fail('No existe usuario mock para prueba');
        }

        // Act & Assert
        expect(
          () => dataSource.login(user.email, 'wrongPassword'),
          throwsA(isA<InvalidCredentialsException>()),
        );
      },
    );
  });

  group('AuthMockDataSource - getCurrentUser', () {
    test('Debe retornar null si no hay sesión iniciada', () async {
      final currentUser = await dataSource.getCurrentUser();
      expect(currentUser, isNull);
    });

    test('Debe retornar el usuario actual después de login', () async {
      final user = dataSource.getUserByEmail('admin@packlead.com');

      if (user == null) {
        fail('No existe usuario mock para prueba');
      }

      await dataSource.login(user.email, user.password);

      final currentUser = await dataSource.getCurrentUser();

      expect(currentUser, isNotNull);
      expect(currentUser!.email, user.email);
    });
  });

  group('AuthMockDataSource - logout', () {
    test('Debe limpiar el usuario actual después de logout', () async {
      final user = dataSource.getUserByEmail('admin@packlead.com');

      if (user == null) {
        fail('No existe usuario mock para prueba');
      }

      await dataSource.login(user.email, user.password);

      await dataSource.logout();

      final currentUser = await dataSource.getCurrentUser();

      expect(currentUser, isNull);
    });
  });

  group('AuthMockDataSource - getUserByEmail', () {
    test('Debe encontrar usuario ignorando mayúsculas/minúsculas', () {
      final userLower = dataSource.getUserByEmail('admin@packlead.com');
      final userUpper = dataSource.getUserByEmail('ADMIN@PACKLEAD.COM');

      expect(userLower, isNotNull);
      expect(userUpper, isNotNull);
      expect(userLower!.id, userUpper!.id);
    });

    test('Debe retornar null si el usuario no existe', () {
      final result = dataSource.getUserByEmail('noexiste@test.com');
      expect(result, isNull);
    });
  });
}
