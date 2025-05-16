import 'package:flutter/material.dart';
import '../services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final _service = PaymentService();
  bool loading = false;
  String? response;

  Future<void> pay(double amount, String phone) async {
    loading = true;
    response = null;
    notifyListeners();

    try {
      response = await _service.pay(amount, phone);
    } catch (e) {
      response = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> validateVoucher(String pin) async {
    loading = true;
    response = null;
    notifyListeners();

    final ok = await _service.validateVoucher(pin);
    response = ok ? 'Voucher válido' : 'Voucher inválido';

    loading = false;
    notifyListeners();
  }
}