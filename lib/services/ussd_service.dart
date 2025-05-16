import 'package:flutter/services.dart';

class UssdService {
  static const MethodChannel _channel = MethodChannel('com.ussd.infoplus/payment');

  /// Envia um código USSD para o sistema nativo via método 'sendUssd'
  /// [ussdCode] no formato "*123#"
  /// Retorna mensagem de sucesso ou erro
  static Future<String?> sendUssd(String ussdCode) async {
    try {
      final String? result = await _channel.invokeMethod('sendUssd', {'code': ussdCode});
      return result;
    } on PlatformException catch (e) {
      return 'Erro ao enviar USSD: ${e.message}';
    }
  }

  /// Exemplo de iniciar pagamento via canal nativo (método customizado)
  static Future<void> startPayment(String paymentData) async {
    try {
      await _channel.invokeMethod('startPayment', paymentData);
    } on PlatformException catch (e) {
      throw 'Erro ao iniciar pagamento: ${e.message}';
    }
  }
}