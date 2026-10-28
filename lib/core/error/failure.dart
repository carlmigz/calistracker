import 'package:calistracker/core/constants/app_strings.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ParseFailure extends Failure {
  const ParseFailure([super.message = AppStrings.parseFailure]);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = AppStrings.storageFailure]);
}
