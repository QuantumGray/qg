extension StringX on String {
  String get currency {
    switch (this) {
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      default:
        return this;
    }
  }

  Validator get validate {
    return Validator(this);
  }
}

class Validator {
  final String data;
  Validator(this.data);

  bool get containsSymbolAt => data.contains('@');
  String? required<T>(T value) {
    if (value == null ||
        value is bool && !value ||
        value is String && value.trim().isEmpty) {
      return 'Dieses Feld ist benötigt.';
    }

    return null;
  }

  String? get emailValidator {
    if (data.trim().isEmpty) {
      return 'Bitte gib eine E-Mail-Adresse ein.';
    }
    final regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    if (!regex.hasMatch(data)) {
      return 'E-Mail Adresse ungültig.';
    }

    return null;
  }

  String? passwordRepeatValidator(String otherPassword) {
    if (otherPassword != data) {
      return 'Passwörter stimmen nicht überein.';
    }
    return null;
  }

  String? get phoneNumberValidator {
    if (data.length < 8) {
      return "invalid";
    }
    return null;
  }
}
