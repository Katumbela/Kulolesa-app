import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kulolesa/pages/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timer_snackbar/timer_snackbar.dart';

import '../../models/user_provider.dart';
import '../../widgets/app_bar.dart';
import '../alertas/sucesso.dart';

class AlterarConta extends StatefulWidget {
  const AlterarConta({Key? key}) : super(key: key);

  @override
  State<AlterarConta> createState() => _AlterarContaState();
}

class _AlterarContaState extends State<AlterarConta> {
  bool processando = false;

  String nome = "";
  String id = "";
  String sobrenome = "";
  String estado = "";
  String telefone = "";
  String quando = "";
  String foto = "";

  void GetDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {

      nome = pref.getString("nome").toString();
      id = pref.getString("id").toString();
      sobrenome = pref.getString("sobrenome").toString();
      estado = pref.getString("estado").toString();
      telefone = pref.getString("telefone").toString();
      quando = pref.getString("quando").toString();
      foto = pref.getString("foto").toString();
    }
    );

    String val = pref.getString("id").toString();
    if (val == "") {

      // if(id == "null"){
      //   Get.to(() => LoginPage());
      // }
    }
  }

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

      // timerSnackbar(
      //   context: context,
      //   backgroundColor: Colors.orange[300],
      //   contentText: "Verifique sua conexão com a internet",
      //   // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
      //   buttonLabel: "",
      //   afterTimeExecute: () => print("Operation Execute."),
      //   second: 8,
      // );
    }
  }


  Future<void> enviarPedidoAlteracao(String idUsuario, String tipoConta, String nomee) async {
    try {
      await FirebaseFirestore.instance.collection('pedidos_de_alteracao').add({
        'id_usuario': idUsuario,
        'tipo_conta': tipoConta,
        'nome': nomee,
        'status': 'pendente', // Você pode adicionar mais campos conforme necessário
        'quando': FieldValue.serverTimestamp(), // Para registrar a data e hora do pedido
      });

      await FirebaseFirestore.instance.collection('notificacoes').add({
        'para': idUsuario,
        'conteudo': "Solicitou alteração do tipo de conta, o seu estado encontra se pendente",
        'nome': nomee,
        'status': 'pendente',
        'lido': false,// Você pode adicionar mais campos conforme necessário
        'quando': FieldValue.serverTimestamp(), // Para registrar a data e hora do pedido
      });
    } catch (error) {
      throw error;
    }
  }



  @override

  void initState() {
    CheckConection();
    super.initState();
    GetDatas();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    return Scaffold(
      appBar: CustomAppBar(titulo: "Alterar estado da conta" ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, top: 40, right: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin:
              const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Colors.black45,
                        ),
                        Text(
                          "Usuário",
                          style: TextStyle(
                              color: Colors.black45,
                              fontFamily: "pp2"
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Icon(Icons.published_with_changes_outlined,
                        size: 55, color: Colors.blue.withOpacity(.6)),
                  ),
                  Container(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.sell_outlined,
                          color: Colors.black45,
                        ),
                        Text(
                          "Vendedor",
                          style: TextStyle(
                              color: Colors.black45,
                              fontFamily: "pp2"
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  "Processo de alteração de conta",
                  style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: "pp2"
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: const Text(
                'Para começar com o processo de alteração da sua conta deverá primeiramente confirmar no botão abaixo e posteriormente submeter o seu documento de identificação pessoal para o nosso suporte (suporte@kulolesa.com), '
                    'após isto receberá a confirmação da conta alterada',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black45,
                    fontFamily: "pp2"
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: ElevatedButton(
                // style: ButtonStyle(
                //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //     RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20.0),
                //     ),
                //   ),
                //
                //   backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
                // ),

                onPressed: () async {
                  setState(() {
                    processando = true;
                  });

                  try {
                    await enviarPedidoAlteracao(userData!.uniqueID, userData!.accountType, userData!.fullName); // Altere para "Usuário" se necessário

                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        duration: const Duration(milliseconds: 200),
                        child: const SucessoAG(titulo: "Seu pedido de alteração"),
                      ),
                    );
                  } catch (error) {
                    timerSnackbar(
                      context: context,
                      backgroundColor: Colors.red[300],
                      contentText: "Ocorreu um erro técnico ao tentar fazer o pedido de alteração de conta",
                      buttonLabel: "",
                      afterTimeExecute: () => print("Ocorreu um erro ao executar."),
                      second: 8,
                    );
                  }

                  setState(() {
                    processando = false;
                  });
                },
                child: processando == false
                    ? const Text(
                  'Solicitar Alteração',

                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Solicitando... ",),
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.blue.shade200,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
