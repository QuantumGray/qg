// ignore_for_file: avoid_positional_boolean_parameters

extension BoolGates on bool {
  bool or(bool other) => other || this;

  bool and(bool other) => other && this;

  bool nor(bool other) => other || !this;

  bool nand(bool other) => other && !this;

  bool get not => !this;

  static bool allOf(List<bool> bools) {
    for (final _bool in bools) {
      if (_bool) {
        continue;
      }
      return false;
    }
    return true;
  }

  bool andAllOf(List<bool> bools) {
    if (!this) {
      return false;
    }
    for (final _bool in bools) {
      if (_bool) {
        continue;
      }
      return false;
    }
    return true;
  }
}
