import 'package:flutter_clean_architecture_boilerplate/data/models/index.dart';
import 'package:flutter_clean_architecture_boilerplate/data/network/rest_client.dart';
import 'package:injectable/injectable.dart';

abstract class UserRemoteDataSource {
  Future<UserResponseRaw> getUser(String userId);
}

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final RestClient _restClient;

  UserRemoteDataSourceImpl(this._restClient);

  @override
  Future<UserResponseRaw> getUser(String userId) {
    return _restClient.getUser(userId);
  }
}
