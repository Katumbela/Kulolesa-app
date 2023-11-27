import 'package:flutter/material.dart';


class DadosPessoais extends StatefulWidget {
  const DadosPessoais({super.key});

  @override
  State<DadosPessoais> createState() => _DadosPessoaisState();
}

class _DadosPessoaisState extends State<DadosPessoais> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: const [
            Text("Seus dados pessoais")
          ],
        ),
      ),
    );
  }
}
