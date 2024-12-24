extension DoubleX on double {
  double toPrecision(int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}

extension NullDoubleX<T extends num> on T {
  T? add(T? other) {
    if (other == null) {
      return null;
    }
    return this + other as T;
  }

  T? subtract(T? other) {
    if (other == null) {
      return null;
    }
    return this - other as T;
  }

  T? multiply(T? other) {
    if (other == null) {
      return null;
    }
    return this * other as T;
  }

  T? divide(T? other) {
    if (other == null) {
      return null;
    }
    return this / other as T;
  }
}

extension NullIntX on int? {
  int? mod(int? other) {
    if (this == null || other == null) {
      return null;
    }
    return this! % other;
  }

  int? intDiv(int? other) {
    if (this == null || other == null) {
      return null;
    }
    return this! ~/ other;
  }
}
