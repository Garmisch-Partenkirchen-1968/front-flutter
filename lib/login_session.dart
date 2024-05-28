import 'package:flutter/material.dart';

class profile with ChangeNotifier {
  String _username = "12";
  String _password = "12";
  String get username => _username;
  String get password => _password;

  void updateUsername(String usernameInput) {
    _username = usernameInput;

    notifyListeners();
  }
  void updatePassword(String passwordInput) {
    _password = passwordInput;

    notifyListeners();
  }

  // void remove() {
  //   _count--;
  //   notifyListeners();
  // }
}
