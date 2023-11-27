import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kulolesa/pages/postar_servicos/postar_acomodacao.dart';
import 'package:kulolesa/pages/postar_servicos/postar_transporte.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timer_snackbar/timer_snackbar.dart';

import '../postar_servicos/postar_actividade.dart';


class Outros extends StatefulWidget {
  const Outros({Key? key}) : super(key: key);

  @override
  State<Outros> createState() => _OutrosState();
}

class _OutrosState extends State<Outros> {
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
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("Operation Execute."),
        second: 10,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    CheckConection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Postar Serviço"),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        margin: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 200),
                    child: AddPost(),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * .33,
                padding: const EdgeInsets.all(2),
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 14.0),
                          child:  Icon(Icons.explore_outlined,
                              size: 35, color: Colors.blue[700]),
                        ),

                        Center(
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child:  Text(
                                "Actividade",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 12.0,
                                  fontFamily: "pp2",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 200),
                    child: const Anounce(),
                  ),
                );
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * .33,
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: Icon(Icons.hotel,
                              size: 35, color: Colors.blue[700]),
                        ),

                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child:  Text(
                              "Espaço",
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 12.0,
                                fontFamily: "pp2",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 200),
                    child: const PostarTransporte(),
                  ),
                );
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * .32,
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Icon(Icons.directions_bus_outlined,
                              size: 35, color: Colors.blue[700]),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child:  Text(
                              "Transporte",
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontFamily: "pp2",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
