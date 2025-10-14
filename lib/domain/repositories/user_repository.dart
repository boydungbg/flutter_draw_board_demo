
import 'package:flutter_clean_architecture_boilerplate/domain/entities/index.dart';

abstract class UserRepository {
  Future<User> getUser(String userId);
}
