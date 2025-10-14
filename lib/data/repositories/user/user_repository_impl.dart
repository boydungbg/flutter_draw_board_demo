import 'package:flutter_clean_architecture_boilerplate/data/sources/remote/index.dart';
import 'package:flutter_clean_architecture_boilerplate/domain/entities/user/user.dart';
import 'package:flutter_clean_architecture_boilerplate/domain/repositories/index.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _userDataSource;

  UserRepositoryImpl(this._userDataSource);

  @override
  Future<User> getUser(String userId) async {
    final userRaw = await _userDataSource.getUser(userId);
    return User.fromJson(userRaw.toJson());
  }
}
