import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:packlead/core/constants/user_roles.dart';
import 'package:packlead/core/errors/auth_exceptions.dart';
import 'package:packlead/core/models/user.dart';
import 'package:packlead/features/auth/data/datasources/auth_datasource.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final fba.FirebaseAuth _fbAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    fba.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _fbAuth = firebaseAuth ?? fba.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> getCurrentUser() async {
    final fbUser = _fbAuth.currentUser;
    if (fbUser == null) return null;

    return _fetchUserFromFirestore(fbUser.uid);
  }

  @override
  Future<User> login(String email, String password) async {
    final credential = await _fbAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) throw const InvalidCredentialsException();

    return _fetchUserFromFirestore(firebaseUser.uid);
  }

  @override
  Future<void> logout() async {
    await _fbAuth.signOut();
  }

  Future<User> _fetchUserFromFirestore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) throw const InvalidCredentialsException();

    final data = doc.data()!;

    return User(
      id: uid,
      email: data['email'] as String,
      password: '',
      name: data['name'] as String,
      role: UserRole.values.byName(data['role'] as String? ?? 'none'),
    );
  }
}