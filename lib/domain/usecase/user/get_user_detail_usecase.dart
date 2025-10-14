import 'package:flutter_clean_architecture_boilerplate/core/exceptions/base_exception.dart';
import 'package:flutter_clean_architecture_boilerplate/domain/entities/index.dart';
import 'package:flutter_clean_architecture_boilerplate/domain/repositories/index.dart';
import 'package:flutter_clean_architecture_boilerplate/domain/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserDetailUseCase extends UseCase<User, String> {
  final UserRepository userRepository;

  GetUserDetailUseCase(this.userRepository);

  @override
  Future<Either<BaseException, User>> call(String userId) async {
    try {
      final user = await userRepository.getUser(userId);
      return Right(user);
    } catch (e) {
      return Left(exceptionHandler.handle(e));
    }
  }
}
