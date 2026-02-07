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
      id: 'disp_001',
      email: 'carlos.disp@packlead.com',
      password: 'carlos123',
      role: UserRole.dispatcher,
    ),
    User(
      id: 'disp_002',
      email: 'ana.disp@packlead.com',
      password: 'ana123',
      role: UserRole.dispatcher,
    ),
    User(
      id: 'disp_003',
      email: 'pedro.disp@packlead.com',
      password: 'pedro123',
      role: UserRole.dispatcher,
    ),
    User(
      id: 'disp_004',
      email: 'maria.disp@packlead.com',
      password: 'maria123',
      role: UserRole.dispatcher,
    ),
    User(
      id: 'disp_005',
      email: 'luis.disp@packlead.com',
      password: 'luis123',
      role: UserRole.dispatcher,
    ),
  ];
}