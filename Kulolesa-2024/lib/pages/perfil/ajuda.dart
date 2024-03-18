import 'package:flutter/material.dart';
import 'package:kulolesa/widgets/app_bar.dart';


class Ajuda extends StatefulWidget {
  const Ajuda({Key? key}) : super(key: key);

  @override
  State<Ajuda> createState() => _AjudaState();
}

class _AjudaState extends State<Ajuda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(titulo: "Obter Ajuda",),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin:
              const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Image.asset(
                  'assets/information (2).png',
                  height: 100.0,
                  width: 100.0,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 14.0, top: 15, right: 14.0),
              child: const Text(
                  'Precisa de ajuda com alguma coisa ? \n Contacta nos enviando um email com a sua dificuldade e responderemos o mais breve possível \n\nEmail: suporte@kulolesa.com \n\n Website: www.kulolesa.com ',
                  style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}
