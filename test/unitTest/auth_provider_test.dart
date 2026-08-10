import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:packlead/core/constants/user_roles.dart';
import 'package:packlead/core/constants/user_status.dart';
import 'package:packlead/core/models/user.dart';
import 'package:packlead/features/auth/data/repositories/auth_repository.dart';
import 'package:packlead/features/auth/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  final user = const User(
    id: 'user-1',
    email: 'admin@packlead.com',
    password: '123456',
    name: 'Admin',
    role: UserRole.admin,
  );

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  Future<AuthStateNotifier> createNotifier() async {
    when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => null);
    final notifier = AuthStateNotifier(mockRepository);
    // Let the constructor's _checkStatus() finish before the test drives more state changes.
    await Future<void>.delayed(Duration.zero);
    return notifier;
  }

  group('AuthStateNotifier - _checkStatus (constructor)', () {
    test('Debe quedar unauthenticated si no hay sesión activa', () async {
      when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => null);

      final notifier = AuthStateNotifier(mockRepository);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.status, AuthStatus.unauthenticated);
      expect(notifier.state.user, isNull);
    });

    test('Debe quedar authenticated si ya existe una sesión activa', () async {
      when(() => mockRepository.getCurrentUser()).thenAnswer((_) async => user);

      final notifier = AuthStateNotifier(mockRepository);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.status, AuthStatus.authenticated);
      expect(notifier.state.user, user);
    });
  });

  group('AuthStateNotifier - login', () {
    test('Debe quedar authenticated cuando el login es exitoso', () async {
      final notifier = await createNotifier();
      when(
        () => mockRepository.login(user.email, user.password),
      ).thenAnswer((_) async => Right(user));

      await notifier.login(user.email, user.password);

      expect(notifier.state.status, AuthStatus.authenticated);
      expect(notifier.state.user, user);
      expect(notifier.state.errorMessage, isNull);
    });

    test('Debe quedar en error cuando el login falla', () async {
      final notifier = await createNotifier();
      when(
        () => mockRepository.login('wrong@packlead.com', 'bad'),
      ).thenAnswer((_) async => const Left('Credenciales inválidas'));

      await notifier.login('wrong@packlead.com', 'bad');

      expect(notifier.state.status, AuthStatus.error);
      expect(notifier.state.errorMessage, 'Credenciales inválidas');
      expect(notifier.state.user, isNull);
    });
  });

  group('AuthStateNotifier - logout', () {
    test('Debe quedar unauthenticated tras un logout exitoso', () async {
      final notifier = await createNotifier();
      when(() => mockRepository.logout()).thenAnswer((_) async {});

      await notifier.logout();

      expect(notifier.state.status, AuthStatus.unauthenticated);
      expect(notifier.state.user, isNull);
    });

    test('Debe quedar en error si logout lanza una excepción', () async {
      final notifier = await createNotifier();
      when(() => mockRepository.logout()).thenThrow(Exception('Fallo de red'));

      await notifier.logout();

      expect(notifier.state.status, AuthStatus.error);
      expect(notifier.state.errorMessage, isNotNull);
    });
  });
}
