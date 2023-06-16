import 'types.dart';

abstract class LoValidator<TIn, TOut> {
  TOut? validate(TIn input);

  /// {@template LoValidator.all}
  /// Checks whether all validators have no error (Like AND).
  /// Returns first error (or [defaultError] if not null) otherwise.
  /// {@endtemplate}
  static ValidateFunc<TIn, TOut> all<TIn, TOut>(
    List<LoValidator<TIn, TOut>> validators, [
    TOut? defaultError,
  ]) {
    return (input) {
      for (final validator in validators) {
        final error = validator.validate(input);
        if (error != null) {
          return defaultError ?? error;
        }
      }

      return null;
    };
  }

  /// {@template LoValidator.any}
  /// Checks whether any validator has no error (Like OR).
  /// Returns first error (or [defaultError] if not null) otherwise.
  /// {@endtemplate}
  static ValidateFunc<TIn, TOut> any<TIn, TOut>(
    List<LoValidator<TIn, TOut>> validators, [
    TOut? defaultError,
  ]) {
    return (input) {
      TOut? firstError;

      for (final validator in validators) {
        final error = validator.validate(input);
        if (error == null) {
          return null;
        } else {
          firstError ??= error;
        }
      }

      if (firstError != null) {
        return defaultError ?? firstError;
      }

      return null;
    };
  }
}
