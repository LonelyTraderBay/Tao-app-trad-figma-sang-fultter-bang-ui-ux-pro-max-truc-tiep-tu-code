sealed class AppFailure {
  const AppFailure(this.message, {this.code, this.cause});

  final String message;
  final String? code;
  final Object? cause;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message, {super.code, super.cause});
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, {super.code, super.cause});
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure(super.message, {super.code, super.cause});
}
