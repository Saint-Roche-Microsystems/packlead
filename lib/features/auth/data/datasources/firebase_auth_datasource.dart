import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:packlead/core/constants/user_roles.dart';
import 'package:packlead/core/errors/auth_exceptions.dart';
import 'package:packlead/core/models/user.dart';
import 'package:packlead/features/auth/data/datasources/auth_datasource.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final fba.FirebaseAuth _fbAuth;

  FirebaseAuthDataSource({
    fba.FirebaseAuth? firebaseAuth,
  }) : _fbAuth = firebaseAuth ?? fba.FirebaseAuth.instance;

  @override
  Future<User?> getCurrentUser() async {
    final fbUser = _fbAuth.currentUser;
    if (fbUser == null) return null;

    return _fetchUserFromClaims(fbUser);
  }

  @override
  Future<User> login(String email, String password) async {
    final credential = await _fbAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) throw const InvalidCredentialsException();

    return _fetchUserFromClaims(firebaseUser);
  }

  @override
  Future<void> logout() async {
    await _fbAuth.signOut();
  }

  Future<User> _fetchUserFromClaims(fba.User fbUser) async {
    final tokenResult = await fbUser.getIdTokenResult();
    final role = tokenResult.claims?['role'] as String?;

    return User(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      password: '',
      name: fbUser.displayName ?? fbUser.email ?? '',
      role: UserRole.values.byName(role ?? 'none'),
    );
  }
}