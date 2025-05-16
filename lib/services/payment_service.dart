import 'package:flutter/services.dart';
import '../config/env.dart';

class PaymentService {
  static const _channel = MethodChannel('infoplus/ussd');

  /// Envia USSD dinamicamente baseado no prefixo do número:
  /// prefixos 84,85 → M-Pesa | 86,87 → e-Mola
  Future<String> pay(double amount, String phone) async {
    // Normaliza para dígitos e sem sinais
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    // Remove código do país se presente
    final local = digits.startsWith('258') ? digits.substring(3) : digits;

    String ussdTemplate;
    if (local.startsWith('84') || local.startsWith('85')) {
      ussdTemplate = Env.mpesaUssdCode; // ex: *840*{amount}#
    } else if (local.startsWith('86') || local.startsWith('87')) {
      ussdTemplate = Env.emolaUssdCode; // ex: *860*{amount}#
    } else {
      throw Exception('Operadora não suportada');
    }

    final code = ussdTemplate
      .replaceAll('{amount}', amount.toString())
      .replaceAll('{phone}', phone);

    final result = await _channel.invokeMethod<String>('sendUssd', {'code': code});
    return result ?? 'Falha no USSD';
  }

  Future<bool> validateVoucher(String pin) async {
    // integração com Cloud Functions para validar PIN
    // placeholder: sempre retorna true
    return true;
  }
}