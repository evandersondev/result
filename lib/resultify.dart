sealed class Result<T> {
  const Result();

  /// Cria um [Result] de sucesso com o valor especificado (ou void).
  const factory Result.success(T value) = Success<T>;

  /// Cria um [Result] de erro com o erro especificado.
  const factory Result.failure(Object error) = Failure<T>;

  /// Retorna true se for um [Result] de sucesso.
  bool get isSuccess => this is Success<T>;

  /// Retorna true se for um [Result] de erro.
  bool get isFailure => this is Failure<T>;

  /// Retorna o erro se for falha, ou null.
  Object? exceptionOrNull();

  /// Retorna o valor se for sucesso, ou null.
  T? getOrNull();

  /// Retorna o valor ou um valor padrão em caso de erro.
  T getOrElse(T defaultValue);

  /// Executa uma função dependendo de o [Result] ser sucesso ou erro.
  R fold<R>(R Function(T value) onSuccess, R Function(Object error) onFailure);

  /// Transforma o valor de sucesso com a função [mapper].
  Result<R> map<R>(R Function(T value) mapper);

  /// Transforma o valor de sucesso, retornando um [Result].
  Result<R> flatMap<R>(Result<R> Function(T value) mapper);

  /// Transforma o erro com a função [mapper] se for falha.
  Result<T> mapError(Object Function(Object error) mapper);

  /// Executa uma função se for sucesso.
  void onSuccess(void Function(T value) action);

  /// Executa uma função se for erro.
  void onFailure(void Function(Object error) action);

  /// Lança o erro se for falha.
  void onFailureThrow();

  /// Combina múltiplos [Result] em um único [Result].
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final values = <T>[];
    for (final result in results) {
      if (result is Failure<T>) {
        return Failure(result.error);
      } else if (result is Success<T>) {
        values.add(result.value as T);
      }
    }
    return Success(values);
  }

  /// Cria um [Result] a partir de uma operação assíncrona.
  static Future<Result<T>> fromAsync<T>(Future<T> Function() action) async {
    try {
      return Result.success(await action());
    } catch (e) {
      return Result.failure(e);
    }
  }
}

/// Subclasse de Result para valores (sucesso).
final class Success<T> extends Result<T> {
  const Success(this.value);

  /// Valor retornado no sucesso (ou null para void).
  final T? value;

  @override
  String toString() => 'Result<$T>.success($value)';

  @override
  Object? exceptionOrNull() => null;

  @override
  T? getOrNull() => value;

  @override
  T getOrElse(T defaultValue) => value ?? defaultValue;

  @override
  R fold<R>(R Function(T value) onSuccess, R Function(Object error) onFailure) {
    return onSuccess(value as T);
  }

  @override
  Result<R> map<R>(R Function(T value) mapper) {
    return Result.success(mapper(value as T));
  }

  @override
  Result<R> flatMap<R>(Result<R> Function(T value) mapper) {
    return mapper(value as T);
  }

  @override
  Result<T> mapError(Object Function(Object error) mapper) {
    return this; // No-op, since it's a success
  }

  @override
  void onSuccess(void Function(T value) action) {
    action(value as T);
  }

  @override
  void onFailure(void Function(Object error) action) {
    // No-op, since it's a success
  }

  @override
  void onFailureThrow() {
    // No-op, since it's a success
  }
}

/// Subclasse de Result para erros (falha).
final class Failure<T> extends Result<T> {
  const Failure(this.error);

  /// Erro retornado em caso de falha.
  final Object error;

  @override
  String toString() => 'Result<$T>.failure($error)';

  @override
  Object? exceptionOrNull() => error;

  @override
  T? getOrNull() => null;

  @override
  T getOrElse(T defaultValue) => defaultValue;

  @override
  R fold<R>(R Function(T value) onSuccess, R Function(Object error) onFailure) {
    return onFailure(error);
  }

  @override
  Result<R> map<R>(R Function(T value) mapper) {
    return Result.failure(error);
  }

  @override
  Result<R> flatMap<R>(Result<R> Function(T value) mapper) {
    return Result.failure(error);
  }

  @override
  Result<T> mapError(Object Function(Object error) mapper) {
    return Result.failure(mapper(error));
  }

  @override
  void onSuccess(void Function(T value) action) {
    // No-op, since it's a failure
  }

  @override
  void onFailure(void Function(Object error) action) {
    action(error);
  }

  @override
  void onFailureThrow() {
    throw ResultException(error);
  }
}

/// Exceção personalizada para falhas de Result.
class ResultException implements Exception {
  final Object error;

  ResultException(this.error);

  @override
  String toString() => 'ResultException: $error';
}

/// Extensões para melhorar a ergonomia do uso de Result.
extension ResultExtensions<T> on Result<T> {
  Result<R> mapSuccess<R>(R Function(T value) mapper) => this is Success<T>
      ? Result.success(mapper((this as Success<T>).value as T))
      : Result.failure((this as Failure<T>).error);

  Result<T> mapFailure(Object Function(Object error) mapper) =>
      this is Failure<T>
          ? Result.failure(mapper((this as Failure<T>).error))
          : this;
}
