import 'package:flutter/material.dart';
import 'login.dart';

class CheckAuth extends StatelessWidget {

  final bool autenticado = false;

  @override
  Widget build(BuildContext context) {
    return autenticado ? FirstScreen() : LoginPage();
  }
}
