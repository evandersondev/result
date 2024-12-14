# Result Library for Dart

A robust utility for handling success and error states in a functional style.

## Features

- Encapsulate success and failure states using `Result`.
- Transform values with `map` and `flatMap`.
- Handle errors gracefully with `mapError`.
- Combine multiple `Result` objects.
- Simplify async operations with `fromAsync`.
- Convenient extensions for ergonomics.

## Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  result: ^1.0.0
```

Then, run:

```bash
flutter pub get
```

## Getting Started

### Basic Usage

```dart
import 'package:result/result.dart';

void main() {
  // Creating a success result
  final success = Result.success("Operation completed successfully");
  print(success); // Output: Result<String>.success(Operation completed successfully)

  // Creating a failure result
  final failure = Result.failure(Exception("An error occurred"));
  print(failure); // Output: Result<String>.failure(Exception: An error occurred)

  // Handling results
  success.fold(
    (value) => print("Success: $value"),
    (error) => print("Failure: $error"),
  );

  failure.fold(
    (value) => print("Success: $value"),
    (error) => print("Failure: $error"),
  );
}
```

### Mapping Success and Failure

```dart
final success = Result.success(42);
final transformedSuccess = success.map((value) => "Value is \$value");
print(transformedSuccess); // Output: Result<String>.success(Value is 42)

final failure = Result.failure("Initial Error");
final transformedFailure = failure.mapError((error) => "Updated Error: \$error");
print(transformedFailure); // Output: Result<String>.failure(Updated Error: Initial Error)
```

### Combining Results

```dart
final results = [
  Result.success(1),
  Result.success(2),
  Result.success(3),
];

final combined = Result.combine(results);
print(combined); // Output: Result<List<int>>.success([1, 2, 3])

final resultsWithFailure = [
  Result.success(1),
  Result.failure("Error"),
];

final combinedWithFailure = Result.combine(resultsWithFailure);
print(combinedWithFailure); // Output: Result<List<int>>.failure(Error)
```

### Asynchronous Usage

```dart
Future<Result<String>> fetchData() async {
  return await Result.fromAsync(() async {
    if (DateTime.now().millisecondsSinceEpoch % 2 == 0) {
      return "Fetched data";
    } else {
      throw Exception("Fetch error");
    }
  });
}

void main() async {
  final result = await fetchData();

  result.fold(
    (value) => print("Success: \$value"),
    (error) => print("Failure: \$error"),
  );
}
```

### Extensions for Improved Ergonomics

```dart
final result = Result.success(10);
final mapped = result.mapSuccess((value) => value * 2);
print(mapped); // Output: Result<int>.success(20)

final errorHandled = result.mapFailure((error) => "Handled: \$error");
print(errorHandled); // Output: Result<int>.success(20)
```

## Testing

### Mocking Success and Failure

```dart
import 'package:test/test.dart';
import 'package:result/result.dart';

void main() {
  test('Success result works correctly', () {
    final result = Result.success(100);

    expect(result.isSuccess, true);
    expect(result.getOrNull(), 100);
    expect(result.exceptionOrNull(), null);
  });

  test('Failure result works correctly', () {
    final result = Result.failure(Exception("Test error"));

    expect(result.isFailure, true);
    expect(result.getOrNull(), null);
    expect(result.exceptionOrNull(), isA<Exception>());
  });

  test('Mapping success works correctly', () {
    final result = Result.success(50);
    final mapped = result.map((value) => value * 2);

    expect(mapped.getOrNull(), 100);
  });

  test('Handling failure works correctly', () {
    final result = Result.failure("Error");
    final handled = result.mapError((error) => "Handled: \$error");

    expect(handled.exceptionOrNull(), "Handled: Error");
  });
}
```

## API Reference

### `Result<T>`

| Method                   | Description                                             |
| ------------------------ | ------------------------------------------------------- |
| `Result.success(T)`      | Creates a success result with a value.                  |
| `Result.failure(Object)` | Creates a failure result with an error.                 |
| `isSuccess`              | Returns `true` if the result is a success.              |
| `isFailure`              | Returns `true` if the result is a failure.              |
| `exceptionOrNull()`      | Returns the error if it's a failure, or `null`.         |
| `getOrNull()`            | Returns the value if it's a success, or `null`.         |
| `getOrElse()`            | Returns the value or a default value if it's a failure. |
| `fold()`                 | Executes a function based on success or failure.        |
| `map()`                  | Transforms the success value with a function.           |
| `flatMap()`              | Transforms the success value into another `Result`.     |
| `mapError()`             | Transforms the error with a function.                   |

### Utility Methods

| Method        | Description                                    |
| ------------- | ---------------------------------------------- |
| `combine()`   | Combines multiple `Result` objects into one.   |
| `fromAsync()` | Wraps an asynchronous operation in a `Result`. |

### Extensions

| Extension      | Description                        |
| -------------- | ---------------------------------- |
| `mapSuccess()` | Maps the success value if present. |
| `mapFailure()` | Maps the error value if present.   |

## Contributing

Contributions are welcome! Please open issues or submit pull requests on the [GitHub repository](https://github.com/evandersondev/result).

## License

This library is licensed under the MIT License. See the `LICENSE` file for details.
