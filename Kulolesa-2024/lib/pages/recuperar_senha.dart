import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/widgets/app_bar.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';

  void _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.sendPasswordResetEmail(email: _email);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('E-mail Enviado'),
              content: Text('Um e-mail de redefinição de senha foi enviado para $_email.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fechar'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Ocorreu um erro ao enviar o e-mail de redefinição de senha.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fechar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Recuperação de Senha"),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding:  EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Insira o email registrado na sua conta Kulolesa", style: TextStyle(
                  fontSize: 14,

                ),),
              ),
              SizedBox(
                height: 30
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  decoration: EstiloApp.estiloTextField(hint: "Insira o email da sua conta", label: "E-mail"),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira um e-mail válido';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _sendPasswordResetEmail,
                child: Text('Enviar E-mail de Redefinição'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
