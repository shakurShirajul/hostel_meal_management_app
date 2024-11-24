import 'package:flutter/material.dart';

class UserEmailProvider extends ChangeNotifier {
  String _userEmail = '';

  String get userEmail => _userEmail;

  void setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }
}