import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  void setAdminByPhone(String phone) {
    _isAdmin = ['+258845216884', '+258876256247'].contains(phone);
    notifyListeners();
  }
}