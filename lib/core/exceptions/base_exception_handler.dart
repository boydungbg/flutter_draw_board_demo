import 'package:flutter_clean_architecture_boilerplate/core/exceptions/base_exception.dart';
import 'package:injectable/injectable.dart';

abstract class BaseExceptionHandler {
  BaseException handle(dynamic any);
}

@Injectable(as: BaseExceptionHandler)
class CommonExceptionHandler implements BaseExceptionHandler {
  @override
  BaseException handle(any) {
    if (any is BaseException) {
      return any;
    }

    return CommonException(message: any.toString());
  }
}
