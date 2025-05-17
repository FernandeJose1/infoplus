import 'package:flutter/services.dart';
import '../config/env.dart';

class PaymentService {
  static const _channel = MethodChannel('infoplus/ussd');

  Future<String> pay(double amount, String phone) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final local = digits.startsWith('258') ? digits.substring(3) : digits;

    String ussdTemplate;
    if (local.startsWith('84') || local.startsWith('85')) {
      ussdTemplate = Env.mpesaUssdCode;
    } else if (local.startsWith('86') || local.startsWith('87')) {
      ussdTemplate = Env.emolaUssdCode;
    } else {
      throw Exception('Operadora não suportada');
    }

    final code = ussdTemplate
      .replaceAll('{amount}', amount.toString())
      .replaceAll('{phone}', phone);

    try {
      final result = await _channel.invokeMethod<String>('sendUssd', {'code': code});
      return result ?? 'Falha no USSD';
    } on PlatformException catch (e) {
      return 'Erro: ${e.message}';
    }
  }

  Future<bool> validateVoucher(String pin) async {
    try {
      final result = await _channel.invokeMethod<bool>('validateVoucher', {'pin': pin});
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}