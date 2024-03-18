import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../models/user_provider.dart';
import '../alertas/sucesso.dart';

class InfoPessoal extends StatefulWidget {
  const InfoPessoal({super.key});

  @override
  _InfoPessoalState createState() => _InfoPessoalState();
}

class _InfoPessoalState extends State<InfoPessoal> {

  String nome = "";
  String id = "";
  String nasciment = "";
  String sobrenome = "";
  String email = "";
  String telefone = "";
  String estado = "";
  TextEditingController uniqueId = TextEditingController();
  TextEditingController sobrenome_ctr = TextEditingController();
  TextEditingController estado_ctr = TextEditingController();
  TextEditingController nascimento = TextEditingController();

  bool processandoPedido = false;
  TextEditingController nome_ctr = TextEditingController();
  TextEditingController telefone_ctr = TextEditingController();
  TextEditingController email_ctr = TextEditingController();

  @override
  void initState() {
    super.initState();
    todosDados();
  }

  Future todosDados() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    setState(() {
      nome_ctr.text = userData!.fullName;
      email_ctr.text = userData.email;
      telefone_ctr.text = userData.phone;
      uniqueId.text = userData.uniqueID;
      nascimento.text = userData.birthdate;
      estado_ctr.text = userData.accountType;
    });

  }

  Future<void> atualizarDados() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uid = userProvider.user!.uniqueID;
    final userData = userProvider.user;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fullName': nome_ctr.text,
        'email': email_ctr.text,
        'phone': telefone_ctr.text,
      });

      await FirebaseFirestore.instance.collection('notificacoes').add({
        'para': userData!.uniqueID,
        'conteudo': "Olá ${userData!.fullName}, seu pedido de alteração de dados foi aprovado com sucesso.",
        'nome': userData!.fullName,
        'foto': "https://firebasestorage.googleapis.com/v0/b/kulolesaapp.appspot.com/o/perfil%2Flogo.png?alt=media&token=8ed4199d-baeb-442c-8613-8b53aef9c5af",
        'status': 'pendente',
        'lido': false,// Você pode adicionar mais campos conforme necessário
        'quando': FieldValue.serverTimestamp(), // Para registrar a data e hora do pedido
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sucesso'),
            content: Text('As informações estão sendo atualizadas, será informado assim que aprovado.'),
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
            content: Text('Ocorreu um erro ao atualizar as informações.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Informações Pessoais"),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: <Widget>[

                Container(
                  margin: const EdgeInsets.only(
                      bottom: 25.0, left: 20.0, top: 40, right: 20.0),
                  child: const Text(
                    'Edite suas informações pessoais',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: uniqueId,
                    enabled: false,
                    decoration: const InputDecoration(
                        labelText: 'ID de usuário',
                        labelStyle: TextStyle(
                          fontFamily: "pp2",
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: nome_ctr,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                    // ],
                    decoration: const InputDecoration(
                        labelText: 'Nome',
                        labelStyle: TextStyle(
                          fontFamily: "pp2",
                        )),
                  ),
                ),
             
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: email_ctr,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontFamily: "pp2",
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: telefone_ctr,
                    keyboardType: TextInputType.number,
                    maxLength: 13,

                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    // ],

                    decoration: const InputDecoration(
                        labelText: 'Telefone',
                        labelStyle: TextStyle(
                          fontFamily: "pp2",
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: estado_ctr,
                    enabled: false,
                    decoration: const InputDecoration(
                        labelText: 'Conta',
                        labelStyle: TextStyle(
                          fontFamily: "pp2",
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 45.0),
                  child: TextFormField(
                    controller: nascimento,
                    enabled: false,
                    decoration: const InputDecoration(
                        labelText: 'Nascimento',
                        labelStyle: TextStyle(
                          fontFamily: "pp2",
                        )),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (!processandoPedido) {
                      setState(() {
                        processandoPedido = true;
                      });

                      atualizarDados().then((_) {
                        setState(() {
                          processandoPedido = false;
                        });
                      });
                    }
                  },
                  child: processandoPedido == false
                      ? const Text(
                    'Solicitar Alteração',
                  )
                      : const SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator(
                        color: Colors.lightBlueAccent,
                        backgroundColor: Colors.blue,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
