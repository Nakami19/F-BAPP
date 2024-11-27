import 'package:f_bapp/infrastructure/auth/privileges.dart';
import 'package:flutter/material.dart';

class PrivilegesProvider with ChangeNotifier {

  List<Privilege>? privileges;

  List<Privilege>? get _privilege => privileges;

  set Setprivileges(List<Privilege>? newPrivilege) {
    privileges = newPrivilege;
    notifyListeners();
  }


}