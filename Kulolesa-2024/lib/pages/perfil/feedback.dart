import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:kulolesa/models/user_provider.dart';
import 'package:provider/provider.dart';


class FeedBack extends StatefulWidget {
  const FeedBack({super.key});


  @override
  _FeedBackState createState() => _FeedBackState();
}


class _FeedBackState extends State<FeedBack> {

  final TextEditingController _feedbackController = TextEditingController();


  String nome = "";
  String linkPhoto = "";

   Future<void> getUserdatas() async{
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    setState(() {
      nome = userData!.fullName;
    });

  }

  bool _load = false;

  void _enviarFeedback() async {

    setState(() {
      _load = true;
    });

    final String feedback = _feedbackController.text;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;


    if (feedback.isNotEmpty) {
      try {
        // Enviar feedback para o Firestore
        await FirebaseFirestore.instance.collection('feedback').add({
          'message': feedback,
          'quando': FieldValue.serverTimestamp(),
          'Usuario': userData!.fullName,
          'idUsuario': userData!.uniqueID,
        });

        setState(() {
          _load = true;
        });
        // Navegar de volta para a tela inicial após o envio
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const SucessoAG(titulo: "Obrigado! \n Seu Feedback")),
        );
      } catch (e) {
        // Lidar com qualquer erro de envio
        print('Erro ao enviar feedback: $e');

        setState(() {
          _load = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserdatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(titulo: "Envie-nos Feedback"),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(bottom: 15.0, top: 30.0),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 22.0),
                child: const Text(
                  'Partilhe o seu FeedBack',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: "pp2",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
                child: const Text(
                    'Ajuda-nos a melhorar, partilhando as suas ideias, problemas ao usar o aplicativo ou agradecimentos. Não podemos responder individualmente, mas iremos transmitir para as equipas que trabalham para tornar o aplicativo melhor para todos'),
              ),


              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: SizedBox(
                    // height: 40.0,
                    // width: 300,
                    child: TextField(
                      controller: _feedbackController, // Controlador do campo de texto
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      maxLength: 500,
                      decoration: EstiloApp.estiloTextField(label: "Seu Feedback", hint: "Escreva o seu feedback")
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              ElevatedButton(
                onPressed: _enviarFeedback, // Chame a função para enviar o feedback
                child: _load ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator()
                ) : Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
