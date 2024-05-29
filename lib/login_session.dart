import 'package:flutter/material.dart';

class profile with ChangeNotifier {
  int _userid = 6;
  String _username = "11";
  String _password = "11";
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
