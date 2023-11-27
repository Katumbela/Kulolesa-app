import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
import 'package:kulolesa/pages/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_snackbar/timer_snackbar.dart';

import '../../models/user_provider.dart';
import '../../widgets/app_bar.dart';


class PostarTransporte extends StatefulWidget {
  const PostarTransporte({super.key});


  @override
  State<PostarTransporte> createState() => _PostarTransporteState();
}

class _PostarTransporteState extends State<PostarTransporte> {
  TextEditingController marca = TextEditingController();
  TextEditingController descricao = TextEditingController();
  TextEditingController partida = TextEditingController();
  TextEditingController preco = TextEditingController();
  TextEditingController onde = TextEditingController();
  TextEditingController lugares = TextEditingController();
  TextEditingController trajecto = TextEditingController();
  bool loading = false;

  String id = "";
  String conta = "";
  String nome = "";
  String telefone = "";

  File? imagem;
  late String _myActivity;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    CheckConnection();
    GetDatas();
  }

  Future<void> EnviarDados() async {
    setState(() {
      loading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;


    final storageBackend = StorageBackend();

    String? imageUrl;
    if (imagem != null) {
      imageUrl = await storageBackend.uploadImagem(imagem!);
    }


    final firebaseBackend = FirebaseBackend();
    final success = await firebaseBackend.enviarDados(
      descricao: descricao.text,
      trajecto: trajecto.text,
      dataPartida: partida.text,
      marca: marca.text,
      onde: onde.text,
      conta: userData!.uniqueID,
      preco: preco.text,
      telefone: userData!.phone,
      lugares: lugares.text,
      imageUrl: imageUrl,
      sponsor: false,
    );

    if (success) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 350),
          child: const SucessoAG(titulo: "Seu transporte"),
        ),
      );




      setState(() {
        loading = false;
      });

    } else {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.red[300],
        contentText: "Ocorreu um erro ao tentar anunciar o seu serviço!",
        buttonLabel: "",
        afterTimeExecute: () =>
            print("Erro ao tentar executar esta ação ..."),
        second: 8,
      );

      setState(() {
        loading = false;
      });
    }
  }

  DateTime _selectedDate = DateTime.now();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Anuncie seu transporte"),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: imagem != null
                          ? Image.file(imagem!)
                          : Container(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 150,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        .4,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius:
                                      BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                      onTap: () => getImagemm(),
                                      child: Icon(
                                        Icons
                                            .enhance_photo_translate_outlined,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0)),
                                  Container(
                                    height: 150,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        .4,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius:
                                      BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                      onTap: () => getImagem(),
                                      child: Icon(
                                        Icons.photo_outlined,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0)),
                              const Text(
                                "Foto da Viatura",
                                style: TextStyle(

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: marca,
                      decoration: const InputDecoration(
                        labelText: "Marca / Viatura",
                        labelStyle: TextStyle(

                        ),
                        prefixIcon: Icon(Icons.directions_bus_filled_outlined,
                            size: 15.0),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30, // Largura mínima do ícone
                          minHeight: 15, // Altura mínima do ícone
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: lugares,
                      decoration: const InputDecoration(
                        labelText: "Lugares  ",
                        labelStyle: TextStyle(

                        ),
                        prefixIcon: Icon(Icons.people_alt_outlined,
                            size: 15.0),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30, // Largura mínima do ícone
                          minHeight: 15, // Altura mínima do ícone
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: TextField(
                      readOnly: true, // Torna o campo de texto somente leitura para evitar entrada direta
                      controller: partida,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025, 12, 31),
                          // locale: Locale('pt'), // Set the locale to Portuguese
                        );

                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                            partida.text = DateFormat('dd/MM/yyyy').format(picked);
                          });
                        }
                      },

                      decoration: InputDecoration(
                        labelText: 'Data de partida',
                        prefixIcon: Icon(Icons.watch_later_outlined, size: 15,),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30, // Largura mínima do ícone
                          minHeight: 15, // Altura mínima do ícone
                        ),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(20.0),
                        //     bottomLeft: Radius.circular(20.0),
                        //   ),
                        //   borderSide: BorderSide.none, // Remove a borda
                        // ),
                        // // Adicione uma borda personalizada ao lado esquerdo
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(0.0),
                        //     bottomLeft: Radius.circular(0.0),
                        //   ),
                        //   borderSide: BorderSide(
                        //     color: Colors.blue,
                        //     width: 1.0,
                        //   ),
                        // ),
                      ),
                    ),
                  ),

                  Container(
                    child: TextFormField(
                      controller: descricao,
                      keyboardType: TextInputType.datetime,
                      // maxLength: 400, // Define o limite máximo de caracteres
                      // maxLines: null,
                      decoration: const InputDecoration(
                        labelText: "Alguma infomação ?",
                        labelStyle: TextStyle(
                        ),
                        prefixIcon:
                        Icon(Icons.textsms_outlined, size: 15.0),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30, // Largura mínima do ícone
                          minHeight: 15, // Altura mínima do ícone
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: TextField(
                      controller: trajecto,
                      decoration: const InputDecoration(
                        labelText: "Ponto de partida",
                        labelStyle: TextStyle(
                        ),
                        prefixIcon: Icon(Icons.arrow_upward_rounded,
                            size: 15.0),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30, // Largura mínima do ícone
                          minHeight: 15, // Altura mínima do ícone
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: onde,
                      decoration: const InputDecoration(
                        labelText: "Ponto de chegada",
                        labelStyle: TextStyle(
                        ),
                        prefixIcon: Icon(Icons.arrow_downward_rounded,
                            size: 15.0),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30, // Largura mínima do ícone
                          minHeight: 15, // Altura mínima do ícone
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: preco,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Seu preço (AOA) / lugar",
                        labelStyle: TextStyle(
                        ),
                        prefixIcon:
                        Icon(Icons.attach_money_rounded, size: 15.0),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30, // Largura mínima do ícone
                          minHeight: 15, // Altura mínima do ícone
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // ... outros campos ...
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        EnviarDados();
                      }
                    },
                    child: loading == false
                        ? const Text(
                      'Anunciar',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    )
                        : const SizedBox(
                      height: 25.0,
                      width: 25.0,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getImagem() async {
    final imgTemp =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imgTemp != null) {
      setState(() {
        imagem = File(imgTemp.path);
      });
    }
  }

  getImagemm() async {
    final imgTemp =
    await ImagePicker().pickImage(source: ImageSource.camera);

    if (imgTemp != null) {
      setState(() {
        imagem = File(imgTemp.path);
      });
    }
  }

  void GetDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("nome").toString();
      id = pref.getString("id").toString();
      conta = pref.getString("tipo").toString();
      telefone = pref.getString("telefone").toString();
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    if (userData == null) {
      if (id == "null") {
        Get.to(() => const LoginPage());
      }
    }
  }

  bool ActiveConnection = false;
  String T = "";

  Future CheckConnection() async {
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
        buttonLabel: "",
        afterTimeExecute: () => print("Operation Execute."),
        second: 8,
      );
    }
  }
}

class FirebaseBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;




  Future<bool> enviarDados({
    required String descricao,
    required String dataPartida,
    required String trajecto,
    required String marca,
    required String onde,
    required String conta,
    required String preco,
    required String telefone,
    required String lugares,
    required String? imageUrl,
    required bool sponsor,
  }) async {
    try {
      await _firestore.collection('transportes').add({
        'descricao': descricao,
        'dataPartida': dataPartida,
        'trajecto': trajecto,
        'marca': marca,
        'onde': onde,
        'conta': conta,
        'preco': preco,
        'telefone': telefone,
        'lugares': lugares,
        'imageUrl': imageUrl,
        'sponsor': false,
        'aprovado': false,
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}

class StorageBackend {
 final _storage = FirebaseStorage.instance;

  Future<String?> uploadImagem(File imagem) async {

      final ref = _storage.ref().child('transportes/${DateTime.now()}.png');
      await ref.putFile(imagem);
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;

  }
}
