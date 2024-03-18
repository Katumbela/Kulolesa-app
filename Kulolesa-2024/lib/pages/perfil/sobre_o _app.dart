import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:timer_snackbar/timer_snackbar.dart';


class ComoFunciona extends StatefulWidget {
  const ComoFunciona({Key? key}) : super(key: key);

  @override
  State<ComoFunciona> createState() => _ComoFuncionaState();
}

class _ComoFuncionaState extends State<ComoFunciona> {
  bool ActiveConnection = false;
  String T = "";
  Future CheckConection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
      });

      timerSnackbar(
        context: context,
        backgroundColor: Colors.orange[300],
        contentText: "Verifique sua conexão com a internet",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("Operation Execute."),
        second: 8,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    CheckConection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Sobre o aplicativo"),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  child: Image.asset(
                    'assets/Ku.png',
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text("Como Funciona a Kulolesa",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 20.0,
                      fontFamily: 'pp2',
                    )),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 25.0),
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: const Text(
                    'Kulolesa é um aplicativo que disponibiliza o app para usuários e vendedores que queiram divulgar seus serviços e para os que queiram encontrar algum serviço de acomodação, Transportes ou actividades. \n\n Na abertura ou cadastro da conta será cadastrado como "Usuário" , poderá solicitar a alteraçao de conta no seu perfil e será aprovado o mais rápido possivel.'
                        '\n\nApós o periodo de teste gratuito, será reposto novas políticas de uso em que na qual todos os usuários receberão estas mesma políticas a vigorar apartir da data de recebimento.'
                        '\n\nTodos os serviços presentes no aplicativo não são prestados pela Kulolesa mas sim pelos seus respectivos prestadores cadastrados na plataforma.',
                    style: TextStyle(fontSize: 15.0, fontFamily: 'pp2')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
