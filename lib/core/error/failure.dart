import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Could not read the training data']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Could not save your progress']);
}
