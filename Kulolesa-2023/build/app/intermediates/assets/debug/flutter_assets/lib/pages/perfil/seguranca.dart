import 'package:flutter/material.dart';
import 'package:kulolesa/widgets/app_bar.dart';



class Seguranca extends StatefulWidget {
  const Seguranca({super.key});

  @override
  _SegurancaState createState() => _SegurancaState();
}

class _SegurancaState extends State<Seguranca> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Políticas de segurança"),
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
                margin: const EdgeInsets.symmetric(vertical: 25),
                child: Image.asset(
                  'assets/shield.png',
                  height: 100.0,
                  width: 100.0,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: const Text(
                  'Obtenha apoio, ferramentas e informações necessárias para estar seguro no aplicativo \n\n Aceda www.kulolesa.web.app ',
                  style: TextStyle(fontSize: 15.0, ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
