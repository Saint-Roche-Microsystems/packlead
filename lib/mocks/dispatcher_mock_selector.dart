import 'dart:math';

import 'package:packlead/core/constants/user_roles.dart';
import 'package:packlead/core/models/user.dart';
import 'package:packlead/mocks/users_mock_data.dart';

class DispatcherCredentials {
  final String email;
  final String password;

  DispatcherCredentials({
    required this.email,
    required this.password,
  });
}

DispatcherCredentials? getRandomMockDispatcher() {
  final users = UsersMockData().users;

  final dispatchers = users.where((user) => user.role == UserRole.dispatcher).toList();

  if (dispatchers.isEmpty) {
    return null;
  }

  final random = Random();
  final randomDispatcher = dispatchers[random.nextInt(dispatchers.length)];

  return DispatcherCredentials(
    email: randomDispatcher.email,
    password: randomDispatcher.password,
  );
}