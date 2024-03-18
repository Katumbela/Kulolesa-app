import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/pages/login_page.dart';
import 'package:kulolesa/pages/perfil/agendamentos.dart';
import 'package:kulolesa/pages/perfil/alterar_conta.dart';
import 'package:kulolesa/pages/perfil/escolher_post_servicos.dart';
import 'package:kulolesa/pages/perfil/feedback.dart';
import 'package:kulolesa/pages/perfil/info_pessoal.dart';
import 'package:kulolesa/pages/perfil/meus_servicos.dart';
import 'package:kulolesa/pages/perfil/politicas_privacidade.dart';
import 'package:kulolesa/pages/perfil/seguranca.dart';
import 'package:kulolesa/pages/perfil/sobre_o%20_app.dart';
import 'package:kulolesa/pages/perfil/termos_de_usuo.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/provider.dart';
import '../models/user_provider.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Future<void> _logout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(UserData(
      uniqueID: "",
      fullName: "",
      email: "",
      phone: "",
      birthdate: "",
      accountType: "",
      profilePic: "",
      password: "", // Inclua os campos necessários aqui
    ));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Navegue de volta para a página de login após o logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  Future<void> _checkLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    if (!isLoggedIn || userData == null || userData.uniqueID.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  final _picker = ImagePicker();
  Future<void> _changeProfilePicture(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        // Mostrar um loading enquanto a imagem é processada
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        // Fazer upload da imagem para o Firebase Storage
        if (userData != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('perfil')
              .child(userData.uniqueID);
          final UploadTask uploadTask =
              storageRef.putFile(File(pickedImage.path));
          final TaskSnapshot uploadSnapshot = await uploadTask;

          // Obter a URL de download da imagem
          final downloadUrl = await uploadSnapshot.ref.getDownloadURL();

          // Atualizar o campo "profile_pic" no Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userData.uniqueID)
              .update({
            'profile_pic': downloadUrl,
          });

          // Fechar o loading
          Navigator.of(context).pop();

          // Mostrar um alerta de sucesso
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Foto de perfil atualizada"),
                content: Text(
                    "Sua foto de perfil está sendo atualizada  com sucesso."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (error) {
      print("Erro ao alterar a foto de perfil: $error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLogin(context);
    Provider.of<UserProvider>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    return Scaffold(
      appBar: CustomAppBar(
        titulo: "Seu Perfil",
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        border:
                            Border.all(color: EstiloApp.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(80.0),
                          child: CachedNetworkImage(
                            imageUrl: userData!.profilePic,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width:
                                    20, // Tamanho do CircularProgressIndicator
                                height:
                                    20, // Tamanho do CircularProgressIndicator
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          _changeProfilePicture(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    )
                  ]),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          userData!.fullName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black),
                        ),
                        Text("Conta: ${userData!.accountType}"),
                        const SizedBox(width: 10),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              userData.accountType != "Usuario"
                                  ? ElevatedButton(
                                      onPressed: () => {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: const Outros(),
                                          ),
                                        )
                                      },
                                      child: const Text("Postar Serviço"),
                                    )
                                  : ElevatedButton(
                                      onPressed: () => {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: const AlterarConta(),
                                          ),
                                        )
                                      },
                                      child: const Text("Alterar Conta"),
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50.withOpacity(.35),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        const SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 40,
                                    spreadRadius: 0)
                              ]),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 300),
                                  child: const InfoPessoal(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child:
                                          Image.asset("assets/padlock (1).png"),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "Dados pessoais",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset("assets/right.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        userData!.accountType != "Usuario"
                            ? Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(.2),
                                              blurRadius: 40,
                                              spreadRadius: 0)
                                        ]),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: PaginasMeusServicos(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: Image.asset(
                                                    "assets/house.png"),
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                "Meus serviços",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                            width: 16,
                                            child:
                                                Image.asset("assets/right.png"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 40,
                                    spreadRadius: 0)
                              ]),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 200),
                                  child: Pagamento(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset("assets/pay.png"),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "Suas reservas",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset("assets/right.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 40,
                                    spreadRadius: 0)
                              ]),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Seguranca(),
                                ),
                              );
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset("assets/shield.png"),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .55,
                                      child: Text(
                                        "Políticas de Segurança",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset("assets/right.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 40,
                                    spreadRadius: 0)
                              ]),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Privacidade(),
                                ),
                              );
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset("assets/person.png"),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .55,
                                      child: Text(
                                        "A Sua Privacidade",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset("assets/right.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 40,
                                    spreadRadius: 0)
                              ]),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Termos(),
                                ),
                              );
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                          "assets/terms-and-conditions.png"),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "Termos de uso",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset("assets/right.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 40,
                                    spreadRadius: 0)
                              ]),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 200),
                                  child: const ComoFunciona(),
                                ),
                              );
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                          "assets/information (2).png"),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "Sobre a Kulolesa",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset("assets/right.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 40,
                                    spreadRadius: 0)
                              ]),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 200),
                                  child: const FeedBack(),
                                ),
                              );
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset("assets/feedback.png"),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .55,
                                      child: Text(
                                        "Envie nos um feedback",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset("assets/right.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.2),
                                    blurRadius: 40,
                                    spreadRadius: 0)
                              ]),
                          child: InkWell(
                            onTap: () {
                              _logout(context);
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Icon(
                                          Icons.logout,
                                          size: 25,
                                        )
                                        // child: Image.asset("assets/feedback.png"),
                                        ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Sair",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),

                                // Container(
                                //   height: 16,
                                //   width: 16,
                                //   child: Image.asset("assets/right.png"),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Center(
                          child: Text(
                            "Versão 4.12.5",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
