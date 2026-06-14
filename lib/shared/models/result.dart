/// Generic Result type untuk error handling tanpa exception.
///
/// Digunakan oleh UseCases dan Repositories untuk mengembalikan
/// hasil yang bisa berupa sukses (data) atau gagal (error message).
///
/// Contoh penggunaan:
/// ```dart
/// final result = await loginUseCase.execute(email, password);
/// result.when(
///   success: (user) => print('Login berhasil: ${user.name}'),
///   failure: (message) => print('Login gagal: $message'),
/// );
/// ```
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message) = Failure<T>;

  /// Pattern matching helper.
  R when<R>({
    required R Function(T data) success,
    required R Function(String message) failure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => success(data),
      Failure<T>(message: final message) => failure(message),
    };
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
