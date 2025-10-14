import 'package:flutter_clean_architecture_boilerplate/core/di/di.dart';
import 'package:flutter_clean_architecture_boilerplate/core/exceptions/base_exception.dart';
import 'package:flutter_clean_architecture_boilerplate/core/exceptions/base_exception_handler.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCase<Type, Params> {
  BaseExceptionHandler? _exceptionHandler;

  BaseExceptionHandler get exceptionHandler {
    _exceptionHandler ??= getIt<BaseExceptionHandler>();
    return _exceptionHandler!;
  }

  Future<Either<BaseException, Type>> call(Params params);
}

abstract class UseCaseSync<Type, Params> {
  BaseExceptionHandler? _exceptionHandler;

  BaseExceptionHandler get exceptionHandler {
    _exceptionHandler ??= getIt<BaseExceptionHandler>();
    return _exceptionHandler!;
  }

  Either<BaseException, Type> call(Params params);
}
