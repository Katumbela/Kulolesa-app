import 'dart:io' ;
import 'package:cool_alert/cool_alert.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
import 'package:kulolesa/pages/postar_servicos/postar_transporte.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_snackbar/timer_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kulolesa/models/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';


import '../perfil/alterar_conta.dart';

class AddPost extends StatefulWidget {
  var UserId;
  AddPost({super.key, this.UserId});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String nome = "";
  String id = "";
  String estado = "";
  String sobrenome = "";
  String conta = "";
  String email = "";

  TextEditingController Actividade = TextEditingController();
  TextEditingController descricao = TextEditingController();
  TextEditingController local = TextEditingController();
  TextEditingController preco = TextEditingController();
  bool loaing = false;

   File? imagem;

  late String _myActivity;
  late String _myActivityResult;
  final formKey = GlobalKey<FormState>();

  _saveForm() {
    setState(() {
      _myActivityResult = _myActivity;
    });
  }

  Future<void> EnviarDados() async {
    setState(() {
      loaing = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;



    final storageBackend = StorageBackend();
    String? imageUrl;
    if (imagem != null) {
      imageUrl = await storageBackend.uploadImagem(imagem!);
    }

    // Salvar os dados no Firestore
    CollectionReference activities = FirebaseFirestore.instance.collection('actividades');
    DocumentReference documentReference = await activities.add({
      'descricao': descricao.text,
      'localizacao': local.text,
      'act': Actividade.text,
      'preco': preco.text,
      'conta': userData!.uniqueID,
      'pro': 'Angola',
      'img': imageUrl,
      'aprovado': false,
      'sponsor': false,
      'estado': selectedState,
      'cidade': selectedCity,
      'pais': selectedCountry,
    });

    Navigator.push(
      context,
      PageTransition(
        type:
        PageTransitionType.rightToLeft,
        duration: const Duration(milliseconds: 200),
        child: const SucessoAG(titulo: "Sua actividade"),
      ),
    );

    // CoolAlert.show(
    //   context: context,
    //   title: "Adicionado com sucesso",
    //   backgroundColor: Colors.green.shade100,
    //   type: CoolAlertType.success,
    //   confirmBtnColor: Colors.blue.shade700,
    //   text: "O seu anuncio está em revisão, será notificado em breve",
    // );

    setState(() {
      loaing = false;
    });
  }


  String selectedCountry = '';
  String selectedState = '';
  String selectedCity = '';



  void GetDatass() async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = userData!.fullName;

      estado = userData!.accountType;
      email = userData!.email;
    });

    if (estado == "Usuario") {
      Get.to(() => const AlterarConta());
    } else {
      print("Vendedor");
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

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';

    CheckConection();

    GetDatass();
  }

  @override
  Widget build(BuildContext context) {

    GetDatass();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;


    return Scaffold(
      appBar:CustomAppBar(titulo: "Adicionar actvidade",),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  child: Center(
                    child: imagem != null
                        ? Image.file(imagem!)
                        : Container(
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 150,
                                  width:
                                  MediaQuery.of(context).size.width *
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
                                      size: 45.0,
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0)),
                                Container(
                                  height: 150,
                                  width:
                                  MediaQuery.of(context).size.width *
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
                                      size: 45.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 8.0)),
                            const Text(
                              "Ilustração da Actividade",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30
                ),
                Container(
                  child: TextField(
                    controller: Actividade,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9.]"))
                    // ],
                    decoration: const InputDecoration(
                        labelText: "Actividade",
                        prefixIcon: Icon(
                          Icons.explore_outlined,
                          size: 15.0,
                        )),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: descricao,
                    maxLength: 400, // Define o limite máximo de caracteres
                    maxLines: null, // Permite que o campo se expanda verticalmente
                    decoration: InputDecoration(
                      labelText: "Descrição da atividade",
                      labelStyle: TextStyle(fontFamily: ""),
                      prefixIcon: Icon(Icons.edit_note_rounded, size: 15.0),
                    ),
                  ),
                ),
                // Container(
                //   child: TextField(
                //     controller: local,
                //     // inputFormatters: [
                //     //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
                //     // ],
                //     decoration: const InputDecoration(
                //       labelText: "Local",
                //       labelStyle: TextStyle(fontFamily: ""),
                //       prefixIcon: Icon(Icons.location_on_outlined, size: 15.0),
                //     ),
                //   ),
                // ),

                Column(
                  children: [
                    CountryStatePicker(
                      onCountryChanged: (ct) => setState(() {
                        selectedCountry = ct;
                        selectedState == null;
                      }),
                      onStateChanged: (st) => setState(() {
                        selectedState = st;
                      }),
                    ),

                    // Country picker
                    // SelectState(
                    //   onCountryChanged: (value) {
                    //     setState(() {
                    //       selectedCountry = value;
                    //     });
                    //   },
                    //   onStateChanged:(value) {
                    //     setState(() {
                    //       selectedState = value;
                    //     });
                    //   },
                    //   onCityChanged:(value) {
                    //     setState(() {
                    //       selectedCity = value;
                    //     });
                    //   },
                    //
                    // ),
                  ],
                ),

                Container(
                  child: TextField(
                    controller: preco,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                    decoration: const InputDecoration(
                        labelText: "Preço (AOA)",
                        prefixIcon: Icon(Icons.attach_money, size: 15.0)),
                  ),
                ),
                SizedBox(
                  height: 20
                ),
                Center(
                  child: userData!.accountType != "Usuario"
                      ? Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: ElevatedButton(
                      // style: ButtonStyle(
                      //   shape: MaterialStateProperty.all<
                      //       RoundedRectangleBorder>(
                      //       RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(20.0),
                      //       )),
                      //   backgroundColor: MaterialStateProperty.all(
                      //       Colors.blue.shade700),
                      // ),
                      onPressed: () {
                        EnviarDados();
                      },
                      child: loaing == false
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
                  )
                      : Container(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 350),
                              child: const AlterarConta(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              "Solicite primeiro a alteração de conta para poder anunciar no Kulolesa",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "",
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child:  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 350),
                            child: const PostarTransporte(),
                          ),
                        );
                      },
                      child: Text(
                        "Ganhe dinheiro com o seu transporte",

                      ),
                    ),
                  ),
                ),
                estado == "Vendedor"
                    ? Container(
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 350),
                            child: const PostarTransporte(),
                          ),
                        );
                      },
                      child: const Text(
                        "anunciar agora",
                        style: TextStyle(
                          fontFamily: "",
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                )
                    : const Text(""),
              ],
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

}


class StorageBackend {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImagem(File imagem) async {
    try {
      final ref = _storage.ref().child('experiencias/${DateTime.now()}.png');
      await ref.putFile(imagem);
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }
}