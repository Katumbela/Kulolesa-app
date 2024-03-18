import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
import 'package:country_state_city_picker/country_state_city_picker.dart';
import '../perfil/alterar_conta.dart';

class Anounce extends StatefulWidget {
  const Anounce({Key? key}) : super(key: key);

  @override
  State<Anounce> createState() => _AnounceState();
}

class _AnounceState extends State<Anounce> {
  TextEditingController espaco = new TextEditingController();
  TextEditingController descricao = new TextEditingController();
  TextEditingController local = new TextEditingController();
  TextEditingController preco = new TextEditingController();
  TextEditingController ate = new TextEditingController();
  bool loaing = false;
  bool cama = false;
  bool wifi = false;
  bool chuveiro = false;
  bool sinal = false;

  String idd = "";
  String conta = "";
  String nome = "";

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
    CollectionReference activities =
        FirebaseFirestore.instance.collection('acomodacoes');
    DocumentReference documentReference = await activities.add({
      'descricao': descricao.text,
      'local': "kulolesa",
      'preco': preco.text,
      'conta': userData!.uniqueID,
      'img': imageUrl,
      'sponsor': false,
      'acom': espaco.text, // Preencha aqui com o valor apropriado
      'servico': "Acomodação", // Preencha aqui com o valor apropriado
      'avaliacao': "4", // Preencha aqui com o valor apropriado
      'cama': cama,
      'wifi': wifi,
      'chuveiro': chuveiro,
      'sinal': sinal,
      'estado': selectedState,
      'cidade': selectedCity,
      'pais': selectedCountry,
      'aprovado': false,
    });

    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        duration: const Duration(milliseconds: 200),
        child: const SucessoAG(titulo: "Seu espaço"),
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

  File? imagem;

  final formKey = new GlobalKey<FormState>();

  void GetDatass() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    setState(() {
      nome == userData!.fullName;
      idd == userData!.uniqueID;
      conta == userData!.accountType;
    });
  }

  String selectedCountry = '';
  String selectedState = '';
  String selectedCity = '';


  @override
  void initState() {
    super.initState();
    GetDatass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(titulo: "Anuncie seu espaço"),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Column(
              children: <Widget>[
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
                                              size: 40),
                                        ),
                                      ),
                                      Padding(
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
                                          child: Icon(Icons.photo_outlined,
                                              color: Colors.blue[700],
                                              size: 40),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 25.0, top: 10),
                                  ),
                                  const Text(
                                    "Foto do espaço",
                                    style: TextStyle(
                                      fontFamily: "",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Checkbox(
                            value: cama,
                            onChanged: (value) {
                              setState(() {
                                cama = value!;
                              });
                            },
                          ),
                          Text("Cama",
                              style: TextStyle(
                                fontSize: 10,
                              ))
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Checkbox(
                            value: wifi,
                            onChanged: (value) {
                              setState(() {
                                wifi = value!;
                              });
                            },
                          ),
                          Text("Wi-Fi",
                              style: TextStyle(
                                fontSize: 10,
                              ))
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Checkbox(
                            value: chuveiro,
                            onChanged: (value) {
                              setState(() {
                                chuveiro = value!;
                              });
                            },
                          ),
                          Text("Chuveiro",
                              style: TextStyle(
                                fontSize: 10,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Checkbox(
                            value: sinal,
                            onChanged: (value) {
                              setState(() {
                                sinal = value!;
                              });
                            },
                          ),
                          Text("Sinal",
                              style: TextStyle(
                                fontSize: 10,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  child: TextField(
                    controller: espaco,
                    decoration: const InputDecoration(
                      labelText: "Nome do espaço",
                      labelStyle: TextStyle(
                        fontFamily: "",
                      ),
                      prefixIcon: Icon(Icons.hotel_outlined, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: descricao,
                    maxLength: 400, // Define o limite máximo de caracteres
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: "Breve descrição do espaço ",
                      labelStyle: TextStyle(
                        fontFamily: "",
                      ),
                      prefixIcon: Icon(Icons.edit_note_rounded, size: 15.0),
                    ),
                  ),
                ),
                // Container(
                //   child: TextF ield(
                //     controller: local,
                //     decoration: const InputDecoration(
                //       labelText: "Localização",
                //       labelStyle: TextStyle(
                //         fontFamily: "",
                //       ),
                //       prefixIcon: Icon(Icons.location_on_outlined, size: 15.0),
                //     ),
                //   ),
                // ),


                Column(
                  children: [
                    // Country picker
                    CountryStatePicker(
                      onCountryChanged: (ct) => setState(() {
                        selectedCountry = ct;
                        selectedState == null;
                      }),
                      onStateChanged: (st) => setState(() {
                        selectedState = st;
                      }),
                    ),

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
                    SizedBox(height: 5),
                    // City typeahead
                  ],
                ),

                Container(
                  child: TextFormField(
                    controller: ate,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontFamily: "",
                        ),
                        labelText: "Disponível até:",
                        prefixIcon: Icon(Icons.calendar_month)),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: preco,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Preço ",
                        labelStyle: TextStyle(
                          fontFamily: "",
                        ),
                        prefixIcon: Icon(
                          Icons.attach_money_outlined,
                          size: 15.0,
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  /*child:  DropDownFormField(
                    titleText: 'Província',
                    hintText: 'Selecionar...',
                    value: _myActivity,
                    onSaved: (value) {
                      setState(() {
                        _myActivity = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _myActivity = value;
                      });
                    },
                    dataSource: const [
                      {
                        "display": "LUANDA",
                        "value": "LUANDA",
                      },
                      {
                        "display": "CABINDA",
                        "value": "CABINDA",
                      },
                      {
                        "display": "BENGUELA",
                        "value": "BENGUELA",
                      },
                      {
                        "display": "MOXICO",
                        "value": "MOXICO",
                      },
                      {
                        "display": "MALANJE",
                        "value": "MALANJE",
                      },
                      {
                        "display": "KWANZA SUL",
                        "value": "KWANZA SUL",
                      },
                      {
                        "display": "CUNENE",
                        "value": "CUNENE",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),*/
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: ElevatedButton(
                      // style: ButtonStyle(
                      //   shape:
                      //   MaterialStateProperty.all<RoundedRectangleBorder>(
                      //       RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(44.0),
                      //       )),
                      //   backgroundColor:
                      //   MaterialStateProperty.all(Colors.blue.shade700),
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
                          : SizedBox(
                              height: 25.0,
                              width: 25.0,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Colors.blue,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }

  getImagem() async {
    final imgTemp = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imgTemp != null) {
      setState(() {
        imagem = File(imgTemp.path);
      });
    }
  }

  getImagemm() async {
    final imgTemp = await ImagePicker().pickImage(source: ImageSource.camera);

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
