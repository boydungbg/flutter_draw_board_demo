import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_boilerplate/data/models/index.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/users/{id}")
  Future<UserResponseRaw> getUser(@Path("id") String id);
}
