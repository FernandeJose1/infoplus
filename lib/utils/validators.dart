class Validators {
  static bool isValidPin(String pin) => RegExp(r'^\d{4,6}$').hasMatch(pin);
}