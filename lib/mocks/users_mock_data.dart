import 'package:packlead/core/constants/user_roles.dart';
import 'package:packlead/core/models/user.dart';

class UsersMockData {
  final List<User> users = [
    User(
      id: 'admin_001',
      email: 'admin@packlead.com',
      password: 'admin123',
      role: UserRole.admin,
    ),
    User(
      id: 'admin_002',
      email: 'maria.admin@packlead.com',
      password: 'maria123',
      role: UserRole.admin,
    ),

    User(
      id: 'dispatcher_001',
      email: 'dispatcher@packlead.com',
      password: 'dispatcher123',
      role: UserRole.dispatcher,
    ),
    User(
      id: 'dispatcher_002',
      email: 'pedro.disp@packlead.com',
      password: 'pedro123',
      role: UserRole.dispatcher,
    ),
    User(
      id: 'dispatcher_003',
      email: 'ana.disp@packlead.com',
      password: 'ana123',
      role: UserRole.dispatcher,
    ),
  ];
}