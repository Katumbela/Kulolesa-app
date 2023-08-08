import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:kulolesaa/Home.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_snackbar/timer_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Inicial.dart';
import 'login.dart';
import 'main.dart';
import 'new.dart';

class HomeScreen extends StatelessWidget {

  bool visivel = false;
  final _controll = ScrollController();
TextEditingController pesquisa = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              controller: _controll,
              padding: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 1,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Image.asset(
                              'assets/bg.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),


                        //abertura dos features da pgina de experiencias

                        Container(

                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .3),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,

                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          height: 180,
                                          width: 180,
                                          child: Card(
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 140,
                                                  width: 180,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: SizedBox.fromSize(
                                                      size: Size.fromRadius(100.0),
                                                      child: Image.asset(
                                                        'assets/welwi.jpeg',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width: 180,
                                                    height: 40,
                                                    padding: EdgeInsets.only(top: 5, left: 8),

                                                    child:Text("Paisagem e Turismo",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "pp2",
                                                        fontSize: 17.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                      Container(
                                        width: 20.0,
                                      ),
                                      Container(
                                          height: 180,
                                          width: 180,
                                          child: Card(
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 140,
                                                  width: 180,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: SizedBox.fromSize(
                                                      size: Size.fromRadius(100.0),
                                                      child: Image.asset(
                                                        'assets/image1.jpeg',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    width: 180,
                                                    height: 40,
                                                    padding: EdgeInsets.only(top: 5, left: 8),

                                                    child:Text("Centro Cultural ABC",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "pp2",
                                                        fontSize: 17.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ],
                                  ),

                                )
                            ),
                          ),
                        ),

                        //fechamento da area dos features das experiencias !!!
                      // area onde tem a caixa de pesquisa de experiencias
                        Center(
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height *.05),
                                  child: Icon(Icons.arrow_back),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.leftToRight,
                                          alignment: Alignment.center,
                                          duration: Duration(milliseconds: 200),
                                          child: SearchBar()),
                                    );
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
                                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height *.005),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Container(
                                          height:45,

                                        decoration: BoxDecoration(
                                        ),

                                          child: Row(
                                              children: <Widget>[
                                                Container(
                                                    margin: EdgeInsets.only(left: 6),
                                                    child: Icon(Icons.search, color: Colors.grey[600]),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(left: 10),
                                                    child: Text("Pesquisar", style: TextStyle(
                                                        color: Colors.grey[700],
                                                      fontFamily: "pp2",
                                                    )),
                                                ),
                                              ]
                                          ),

                                        ),
                                      ),
                                ),
                              ),
                                  Visibility(
                                    visible: visivel,
                                    child: Container(
                                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
                                      height: MediaQuery.of(context).size.height * .6,
                                      width: MediaQuery.of(context).size.width * .9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.all(12),
                                        child: Container(
                                          child: Text("Pesquisa", style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30.0,
                                            fontFamily: "pp2",
                                          ),
                                          ),
                                        )
                                      ),
                                    ),
                                  )
                            ],
                          ),
                          ),
                      // fechamento da area onde tem o campode pesquisa das esperiencias

                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .83,
                              left: 6.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          width: MediaQuery.of(context).size.width * .95,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Encontre aqui a experiência perfeita',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                    fontFamily: "pp2",
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  final screenHeight = MediaQuery.of(context).size.height *.6;

                                  // If you don't want any animation, use this:
                                  _controll.jumpTo(screenHeight);

                                  // Otherwise use this:
                                  _controll.animateTo(screenHeight, curve: Curves.linearToEaseOut, duration: Duration(milliseconds: 600));

                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          .02),
                                  height: 30.0,
                                  child: Center(
                                      child: Icon(
                                    Icons.arrow_circle_down,
                                    color: Colors.white,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * .95,
                      margin: EdgeInsets.only(top: 30, left: 0),
                      child: Row(
                        children: [
                          Text(
                            'Inspiração Para proxima viagem  ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.lightBlue,
                              fontFamily: "pp2",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.airplanemode_active,
                            size: 15,
                            color: Colors.lightBlue,
                          ),
                        ],
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * .95,
                    child: Divider(
                      color: Colors.lightBlue,
                      thickness: 2.0,
                    ),
                  ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 350),
                                    child: Expe(prov: "Luanda"),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(100.0),
                                        child: Image.asset(
                                          'assets/lua.jpeg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),

                                  //CONTAINER DO QUADRADO ONDE CONSTA O NOME DA PROVINCIA

                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15.0, top: 125.0),
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 5.0),
                                    height: 90.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade600
                                            .withOpacity(.7),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0))),
                                    child: Text(
                                      'LUANDA',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'pp2',
                                          fontSize: 26.0,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 350),
                                    child: Expe(prov: "Benguela"),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(100.0),
                                        child: Image.asset(
                                          'assets/mussulo.jpeg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15.0, top: 125.0),
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 5.0),
                                    height: 90.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade600
                                            .withOpacity(.7),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0))),
                                    child: Text(
                                      'BENGUELA',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          fontFamily: 'pp2',
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 350),
                                    child: Expe(prov: "Bié"),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(100.0),
                                        child: Image.asset(
                                          'assets/way.jpeg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15.0, top: 125.0),
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 5.0),
                                    height: 90.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade600
                                            .withOpacity(.7),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0))),
                                    child: Text(
                                      'BIÉ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 350),
                                    child: Expe(prov: "Kwanza Sul"),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(100.0),
                                        child: Image.asset(
                                          'assets/lua.jpeg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15.0, top: 125.0),
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 5.0),
                                    height: 90.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade600
                                            .withOpacity(.7),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0))),
                                    child: Text(
                                      'KWANZA SUL',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 350),
                                    child: Expe(prov: "Malanje"),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(100.0),
                                        //malanje
                                        child: Image.asset(
                                          'assets/malanje.jpeg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15.0, top: 125.0),
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 5.0),
                                    height: 90.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade600
                                            .withOpacity(.7),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0))),
                                    child: Text(
                                      'MALANJE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 350),
                                    child: Expe(prov: "Namibe"),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(100.0),
                                        child: Image.asset(
                                          'assets/welwi.jpeg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15.0, top: 125.0),
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 5.0),
                                    height: 90.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade600
                                            .withOpacity(.7),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0))),
                                    child: Text(
                                      'NAMIBE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 350),
                                    child: Expe(prov: "Huambo"),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(100.0),
                                        child: Image.asset(
                                          'assets/huambo.jpeg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15.0, top: 125.0),
                                    padding:
                                        EdgeInsets.only(top: 15.0, left: 5.0),
                                    height: 90.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade600
                                            .withOpacity(.7),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0))),
                                    child: Text(
                                      'HUAMBO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .95,
                    child: Divider(
                      color: Colors.lightBlue,
                      thickness: 2.0,
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
}

//-.....--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//PAGINA PARA A FUNCAO TRANSPORTES DA PAGINA INICIAL

class TransPort extends StatefulWidget {
  var tudo;
  TransPort({this.tudo});

  @override
  State<TransPort> createState() => _TransPortState();
}

class _TransPortState extends State<TransPort> {

  String vazio = "";

  @override
  void initState() {
    super.initState();

    if (widget.tudo == null ){
        vazio = "Nã foi encontrado nenhum resultado para sua busca, tente pesquisar por um ponto de chegada, por exemplo \"Luanda\"";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(

        iconTheme: IconThemeData(
          color:Colors.grey[800], //change your color here
        ),
        elevation: 0,
        title:  Text(

          "Transportes Disponíveis",
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 25.0,
            fontFamily: "pp2",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[

              widget.tudo.length == 0 ? Padding(
                padding: const EdgeInsets.all(14.0),
                child: Center(child: Container(
                  margin: EdgeInsets.only(top: 40.0),

                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        child: Image.asset(
                    'assets/information (2).png',
                    height: 80.0,
                    width: 80.0,
                  ),

                      ),
                      Container(
                        height: 30.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child: Text("Não foi encontrado nenhum ponto de chegada para sua pesquisa!\nTente pesquisar por outro ponto de chegada, por exemplo: Luanda",
                             textAlign: TextAlign.center, style: TextStyle(
                                fontSize: 15.0,
                              fontFamily: "pp2",
                                  color: Colors.grey[600],
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),)),
              ) : Container( height: 5.0,),

              Container(
                margin: EdgeInsets.only(top: 0, bottom: 5),
                padding: EdgeInsets.only(top: 10, bottom: 125),
                child: Stack(
                  children: <Widget>[

                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 0.0, left: 3.0, right: 3.0, bottom: 10),

                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              
                              width: MediaQuery.of(context).size.width * 1,
                              margin: EdgeInsets.only(bottom: 70.0),
                              child: ListView.builder(
                                itemCount: widget.tudo.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12.0, top: 5),
                                    child: Card(
                                      borderOnForeground: true,
                                      shadowColor: Colors.blue[400],
                                      child: ListTile(
                                        title: Container(
                                          margin: EdgeInsets.only(top: 10.0, bottom: 0),
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  .25,
                                          child: ImageNetwork(
                                            image:
                                                'https://kulolesaa.000webhostapp.com/trans/${widget.tudo[index]['foto_carro']}',
                                            duration: 300,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .2,
                                            height: double.infinity,
                                            curve: Curves.easeIn,
                                            onPointer: true,
                                            debugPrint: false,
                                            fullScreen: false,
                                            fitAndroidIos: BoxFit.cover,
                                            fitWeb: BoxFitWeb.cover,
                                            onLoading:
                                                const CircularProgressIndicator(
                                              color: Colors.blueAccent,
                                            ),
                                            onError: const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),

                                        /* title:
                                              ),*/
                                        subtitle: Column(children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 5.0, bottom: 5.0),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              widget.tudo[index]['marca'],
                                              style: TextStyle(
                                                color: Colors.blue[700],
                                                fontSize: 25.0,
                                                fontFamily: 'pp2',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .9,
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.arrow_upward_outlined,
                                                          color: Colors.grey[700],
                                                          size: 18),
                                                      Container(
                                                        child: Text("  " +
                                                            widget.tudo[index]['trajecto'],
                                                          style: TextStyle(
                                                            color: Colors.grey[600],
                                                            fontFamily: 'pp2',
                                                          ),),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  child: Column(
                                                    children: <Widget>[

                                                      Container(
                                                        child: Text("Parte em:",
                                                          style: TextStyle(
                                                            color: Colors.grey[600],
                                                            fontFamily: 'pp2',
                                                            fontSize: 10,
                                                          ),),
                                                      ),
                                                      Container(
                                                        child: Text("  " +
                                                            widget.tudo[index]['quando_sai'],
                                                          style: TextStyle(
                                                            color: Colors.grey[600],
                                                            fontFamily: 'pp2',
                                                            fontSize: 10,
                                                          ),),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Icon(
                                                    Icons.arrow_downward_outlined,
                                                    color: Colors.grey[700],
                                                    size: 18),
                                                Text("  " + widget.tudo[index]['para'],
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontFamily: 'pp2',
                                                  ),),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "AOA",
                                                        style: TextStyle(
                                                          color: Colors.grey[800],
                                                          fontSize: 10.0,
                                                          fontFamily: 'pp2',
                                                        ),
                                                      ),
                                                      Text(
                                                          "${" " + widget.tudo[index]['preco']} ",
                                                        style: TextStyle(
                                                          color: Colors.grey[800],
                                                          fontSize: 25.0,
                                                          fontFamily: 'pp2',
                                                        ),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .blue.shade700),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type: PageTransitionType
                                                              .scale,
                                                          alignment:
                                                              Alignment.center,
                                                          duration: Duration(
                                                              milliseconds: 700),
                                                          child: Services(
                                                              img: widget.tudo[index]
                                                                  ['foto_carro'],
                                                              telefone: widget.tudo[
                                                                      index]
                                                                  ['telefone'],
                                                              onde: widget.tudo[index]
                                                                  ['trajecto'],
                                                              preco: widget.tudo[index]
                                                                  ['preco'],
                                                              marca: widget.tudo[index]
                                                                  ['marca'],
                                                              id: widget.tudo[index]
                                                                  ['id'],
                                                              lugares: widget.tudo[index]
                                                                  ['lugares'],
                                                              para: widget.tudo[index]
                                                                  ['para'],
                                                              quando_sai: widget.tudo[index]
                                                                  ['quando_sai'],
                                                              user: widget.tudo[index]
                                                                  ['usuario']),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'Agendar',
                                                      style: TextStyle(
                                                          fontFamily: 'pp2',
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            //AQUI VAI CONSTAR TODAS AS CENAS ABAIXO DO DO TITULO TRANSPORTES E OS SERVIÇOS
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//Pagina das acomodações da pagina inicial

class Acomodacao extends StatefulWidget {
  var prov, pais;
  Acomodacao({this.prov, this.pais});

  @override
  State<Acomodacao> createState() => _AcomodacaoState();
}

class _AcomodacaoState extends State<Acomodacao> {
  bool processand = false;
  String id = "";
  String conta = "";
  String nome = "";
  String sobrenome = "";
  String quando = "";
  String foto = "";

  Future GetDatasAc() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/show_ac.php");


    var digitadoo = {
      "prov": widget.prov,
    };

    final pesquisarr = await http.post(link, body: digitadoo);
    final ress = jsonDecode(pesquisarr.body);
    print(ress);
    return jsonDecode(pesquisarr.body);
  }

  void GetDatass() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("nome").toString();
      id = pref.getString("id").toString();
      foto = pref.getString("foto").toString();
      conta = pref.getString("tipo").toString();
      sobrenome = pref.getString("sobrenome").toString();
      quando = pref.getString("quando").toString();
    });

    String valL = pref.getString("id")!;
    if (valL == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  bool ActiveConnection = false;
  String T = "";
  Future CheckConection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("Conectado a internet");
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
        second: 8,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    GetDatass();
      CheckConection();
    GetDatasAc();
  }

  Widget image() {
    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(


            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:10.0, right: 10.0, top:30.0),
                child: Container(
                child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                Text('Olá '+ nome.toString(), style: TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: "pp2",
                                ),),

                                Text("Acomodações em " + widget.prov, style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: "pp2",
                                ),),
                              ]
                            ),


                          Container(
                            height: 50.0,
                            margin: EdgeInsets.only(bottom: 10.0),
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.blue[300],
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(50.0),
                              child: CachedNetworkImage(
  imageUrl: 'https://kulolesaa.000webhostapp.com/perfil/' + foto,
  placeholder: (context, url) => CircularProgressIndicator(), // Indicador de carregamento enquanto a imagem é buscada na internet
  errorWidget: (context, url, error) => Icon(Icons.error), // Widget a ser exibido em caso de erro ao carregar a imagem
),

                              //Image.network( fit: BoxFit.cover,),

                              /*  Image.network("https://kulolesaa.000webhostapp.com/perfil/img1.png",
                                         fit: BoxFit.cover,),*/
                            ),
                          ),

                        ],
                      ),
                    ],
                ),
            ),
              ), // termino da area de do topo

              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                margin: EdgeInsets.only(left: 10.0, top: 15.0,  right: 10),
                child: Row(
                  children: [
                    Text("Em Destaque", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "pp2",
                        color: Colors.grey[800]
                      ),
                    ),

                     Spacer(),

                     Container(
                       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                       decoration: BoxDecoration(
                         color: Colors.grey[200],
                         borderRadius: BorderRadius.circular(90),
                       ),
                       child:  InkWell(
                         onTap: () {
                           Navigator.push(
                             context,
                             PageTransition(
                               type: PageTransitionType.bottomToTop,
                               duration: Duration(milliseconds: 300),
                               child: HomePage1(),
                             ),
                           );
                         },
                         child: Container(
                           padding: EdgeInsets.only(left: 10),
                           margin: EdgeInsets.only(right: 10),
                           child: Icon(Icons.home,
                               color: Colors.grey[600], size: 30.0),
                         ),
                       ),
                     ),
                  ],
                ),
              ), // termino da parte que fala em destaque

              SizedBox(
                height: 10.0,
              ),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 10.0),
                      Stack(

                        children: <Widget>[


                          Container(
                              height: 300,
                              foregroundDecoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Image border
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(110), // Image radius
                                  child: Image.asset('assets/HOT2.jpeg', fit: BoxFit.cover),
                                ),
                              )
                          ),

                          Positioned(
                            child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black45?.withOpacity(0.3),

                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      margin: EdgeInsets.only(left: 5, top: 5),
                                      child:  FavoriteButton(
                                        isFavorite: false,
                                        iconSize: 30.0,

                                        // iconDisabledColor: Colors.white,
                                        valueChanged:
                                            (_isFavorite) {
                                          if (_isFavorite == true) {
                                            setFavs(_isFavorite);
                                            // if(resposta == 200){
                                            //   timerSnackbar(
                                            //     context: context,
                                            //     backgroundColor:
                                            //     Colors.green[
                                            //     300],
                                            //     contentText:
                                            //     "Acomodação ${dados[index]['espaco']} adicionado aos favoritos !",
                                            //     // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
                                            //     buttonLabel: "",
                                            //     afterTimeExecute:
                                            //         () => print(
                                            //         "Acomodacao adicionada com sucesso!"),
                                            //     second: 2,
                                            //   );
                                            // }

                                          } else {
                                            timerSnackbar(
                                              context: context,
                                              backgroundColor:
                                              Colors
                                                  .red[300],
                                              contentText:
                                              "Acomodação foi removido dos dos favoritos !",
                                              // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
                                              buttonLabel: "",
                                              afterTimeExecute:
                                                  () => print(
                                                  "Acomodacao removida com sucesso!"),
                                              second: 3,
                                            );
                                          }
                                        },
                                      ),

                                    ),
                                  ],
                                )
                            ),
                          ),

                          Positioned(
                            bottom: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(Icons.location_on_outlined, color: Colors.white60),
                                                  Text("Luanda", style: TextStyle(

                                                    color: Colors.white60,
                                                    fontFamily: "pp2",
                                                  ),),
                                                ]
                                            ),

                                            Container(
                                              width:155.0,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text("Hotel Joao, cijnceciniui",
                                                overflow: TextOverflow.ellipsis, style: TextStyle(
                                                  fontFamily: "pp2",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            )
                                          ]
                                      ),
                                    ),

                                    Container(
                                      child: Row(

                                          children: <Widget>[
                                            Icon(Icons.star, size: 20, color: Colors.yellow[600]),
                                            Container(
                                              child: Text("4.1", style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "pp2",
                                              ),),
                                            )
                                          ]
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25.0),
                      Stack(

                        children: <Widget>[


                          Container(
                              height: 300,
                              foregroundDecoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Image border
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(110), // Image radius
                                  child: Image.asset('assets/HOT2.jpeg', fit: BoxFit.cover),
                                ),
                              )
                          ),

                          Positioned(
                            child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black45?.withOpacity(0.3),

                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      margin: EdgeInsets.only(left: 5, top: 5),
                                      child:  FavoriteButton(
                                        isFavorite: false,
                                        iconSize: 30.0,

                                        // iconDisabledColor: Colors.white,
                                        valueChanged:
                                            (_isFavorite) {
                                          if (_isFavorite == true) {
                                            setFavs(_isFavorite);
                                            // if(resposta == 200){
                                            //   timerSnackbar(
                                            //     context: context,
                                            //     backgroundColor:
                                            //     Colors.green[
                                            //     300],
                                            //     contentText:
                                            //     "Acomodação ${dados[index]['espaco']} adicionado aos favoritos !",
                                            //     // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
                                            //     buttonLabel: "",
                                            //     afterTimeExecute:
                                            //         () => print(
                                            //         "Acomodacao adicionada com sucesso!"),
                                            //     second: 2,
                                            //   );
                                            // }

                                          } else {
                                            timerSnackbar(
                                              context: context,
                                              backgroundColor:
                                              Colors
                                                  .red[300],
                                              contentText:
                                              "Acomodação foi removido dos dos favoritos !",
                                              // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
                                              buttonLabel: "",
                                              afterTimeExecute:
                                                  () => print(
                                                  "Acomodacao removida com sucesso!"),
                                              second: 3,
                                            );
                                          }
                                        },
                                      ),

                                    ),
                                  ],
                                )
                            ),
                          ),

                          Positioned(
                            bottom: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(Icons.location_on_outlined, color: Colors.white60),
                                                  Text("Luanda", style: TextStyle(

                                                    color: Colors.white60,
                                                    fontFamily: "pp2",
                                                  ),),
                                                ]
                                            ),

                                            Container(
                                              width:155.0,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text("Hotel Joao, cijnceciniui",
                                                overflow: TextOverflow.ellipsis, style: TextStyle(
                                                  fontFamily: "pp2",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            )
                                          ]
                                      ),
                                    ),

                                    Container(
                                      child: Row(

                                          children: <Widget>[
                                            Icon(Icons.star, size: 20, color: Colors.yellow[600]),
                                            Container(
                                              child: Text("4.1", style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "pp2",
                                              ),),
                                            )
                                          ]
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25.0),
                      Stack(

                        children: <Widget>[


                          Container(
                              height: 300,
                              foregroundDecoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Image border
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(110), // Image radius
                                  child: Image.asset('assets/HOT2.jpeg', fit: BoxFit.cover),
                                ),
                              )
                          ),

                          Positioned(
                            child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black45?.withOpacity(0.3),

                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      margin: EdgeInsets.only(left: 5, top: 5),
                                      child:  FavoriteButton(
                                        isFavorite: false,
                                        iconSize: 30.0,

                                        // iconDisabledColor: Colors.white,
                                        valueChanged:
                                            (_isFavorite) {
                                          if (_isFavorite == true) {
                                            setFavs(_isFavorite);
                                            // if(resposta == 200){
                                            //   timerSnackbar(
                                            //     context: context,
                                            //     backgroundColor:
                                            //     Colors.green[
                                            //     300],
                                            //     contentText:
                                            //     "Acomodação ${dados[index]['espaco']} adicionado aos favoritos !",
                                            //     // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
                                            //     buttonLabel: "",
                                            //     afterTimeExecute:
                                            //         () => print(
                                            //         "Acomodacao adicionada com sucesso!"),
                                            //     second: 2,
                                            //   );
                                            // }

                                          } else {
                                            timerSnackbar(
                                              context: context,
                                              backgroundColor:
                                              Colors
                                                  .red[300],
                                              contentText:
                                              "Acomodação foi removido dos dos favoritos !",
                                              // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
                                              buttonLabel: "",
                                              afterTimeExecute:
                                                  () => print(
                                                  "Acomodacao removida com sucesso!"),
                                              second: 3,
                                            );
                                          }
                                        },
                                      ),

                                    ),
                                  ],
                                )
                            ),
                          ),

                          Positioned(
                            bottom: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(Icons.location_on_outlined, color: Colors.white60),
                                                  Text("Luanda", style: TextStyle(

                                                    color: Colors.white60,
                                                    fontFamily: "pp2",
                                                  ),),
                                                ]
                                            ),

                                            Container(
                                              width:155.0,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text("Hotel Joao, cijnceciniui",
                                                overflow: TextOverflow.ellipsis, style: TextStyle(
                                                  fontFamily: "pp2",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            )
                                          ]
                                      ),
                                    ),

                                    Container(
                                      child: Row(

                                          children: <Widget>[
                                            Icon(Icons.star, size: 20, color: Colors.yellow[600]),
                                            Container(
                                              child: Text("4.1", style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "pp2",
                                              ),),
                                            )
                                          ]
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.0),
                    ]
                  ),
                ),
              ), // termino do scroll horizontal dos destaques


              Container(
                child: Column(
                  children: <Widget>[

                SizedBox(
                    height: 25.0,
                ),
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                      margin: EdgeInsets.only(left: 10.0, top: 15.0,  right: 10),
                      child: Text("Acomodações Disponíveis", style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "pp2",
                      ),
                      ),
                    ),

                    SizedBox(
                      height: 5.0,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * .80,
                      child: FutureBuilder(
                          future: GetDatasAc(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                            }

                            return snapshot.hasData
                                ? ListView.builder(
                                    itemCount: snapshot.data.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      List dados = snapshot.data;
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration: Duration(
                                                  milliseconds:
                                                  100),
                                              child: ReservarH(
                                                  foto: dados[index]
                                                  ['foto'],
                                                  id: dados[index]
                                                  ['id']
                                                      .toString(),
                                                  espaco: dados[index]['espaco']
                                                      .toString(),
                                                  telefone: dados[index]['telefone']
                                                      .toString(),
                                                  classificacao:
                                                  dados[index]['classificacao']
                                                      .toString(),
                                                  quem: dados[index]['usuario']
                                                      .toString(),
                                                  disp: dados[index][
                                                  'disponivel'],
                                                  onde: dados[index][
                                                  'localizacao']
                                                      .toString(),
                                                  desc: dados[index][
                                                  'descricao']
                                                      .toString(),
                                                  preco: dados[index]
                                                  ['preco']
                                                      .toString()),
                                            ),
                                          );
                                        },
                                        child: ListTile(
                                          minLeadingWidth:
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .2,
                                          minVerticalPadding: 0,
                                          title: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(40.0),
                                                  topLeft: Radius.circular(40.0),
                                              ),
                                            ),

                                            margin: EdgeInsets.only(
                                                top: 15.0, bottom: 10.0),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .3,
                                            child: Image(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                'https://kulolesaa.000webhostapp.com/acomodacaoK/${dados[index]['foto']}',
                                              ),
                                            ),

                                            //Image.network( fit: BoxFit.cover,),

                                            // child: Image.network('http://gokside.myartsonline.com/acomodacaoK/img2.jpeg',),
                                          ),
                                          subtitle: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 15.0),
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    dados[index]['espaco' ]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 20.0,
                                                      color: Colors.black,
                                                      fontFamily: "pp2",
                                                    ),
                                                  ),
                                                ),
                                              Container(
                                                    margin: EdgeInsets.only(
                                                        top: 8.0),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.place_outlined,
                                                          size: 15.0,
                                                          color:
                                                              Colors.blue[700],
                                                        ),
                                                        Text(
                                                            "  ${dados[index]['localizacao']}", style: TextStyle(
                                                          fontFamily: "pp2",
                                                        )),
                                                      ],
                                                    ),
                                              ),
                                                Container(
                                                  margin: const EdgeInsets.only(bottom: 2.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [

                                                      Container(
                                                        alignment:
                                                        Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .attach_money_outlined,
                                                              color:
                                                              Colors.blue[700],
                                                              size: 16.0,
                                                            ),
                                                            Text(
                                                              "  ${dados[index]['preco']}", style: TextStyle(
                                                              fontFamily: "pp2",
                                                              fontSize: 22,
                                                            ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                        Alignment.topLeft,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .star,
                                                              color:
                                                              Colors.yellow[700],
                                                              size: 20.0,
                                                            ),

                                                            Text(
                                                              "  ${dados[index]['classificacao']}", style: TextStyle(
                                                              fontFamily: "pp2",
                                                              fontSize: 22,
                                                            ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                     ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                : Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Center(
                                      child: Text("Não foi encontrado nenhum resultado para sua busca, tente noutra cidade!", textAlign: TextAlign.center, style: TextStyle(
                                        color: Colors.grey[700],
                                        fontFamily: "pp2",
                                      )),
                                      // CircularProgressIndicator(
                                      // color: Colors.lightBlueAccent,
                                      // backgroundColor: Colors.white,
                                    ),
                                );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      //aqui comeca a parte das cenas de sugestoes
    );
  }
  Future setFavs(varr) async {
    final t = varr;
    var url = Uri.parse("https://kulolesaa.000webhostapp.com/my_favs_add.php");

    var digitado = {
      "meu_id": t,
      "serv_id": id,
    };

    final pesquisar = await http.post(url, body: digitado);

    var res = jsonDecode(pesquisar.body);
    print(res);
  }
}

class Favoritos extends StatefulWidget {
  const Favoritos({Key? key}) : super(key: key);

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: false,
        title: Text(" Favoritos ", style: TextStyle(fontFamily: "pp2",)),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .1),
                child: Image.asset(
                  "assets/fav.webp",
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width * .3,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Services extends StatefulWidget {
  var img, marca, quando_sai, id, user, onde, para, telefone, preco, lugares;

  Services(
      {this.img,
      this.marca,
      this.id,
      this.telefone,
      this.lugares,
      this.preco,
      this.user,
      this.onde,
      this.quando_sai,
      this.para}
      );

  @override
  State<Services> createState() => _ServicesState();
}


class _ServicesState extends State<Services> {
  bool ActiveConnection = false;
  TextEditingController lugares = new TextEditingController();
  String T = "";

  String dropdownValue = '1 Lugar';



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
        second: 8,
      );
    }
  }


  String avc = "";
  String nome = "";
  String meuid = "";
  String conta = "";
  String sobrenome = "";
  String telefone = "";

  void GetDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nome = pref.getString("nome").toString();
      meuid = pref.getString("id").toString();
      sobrenome = pref.getString("sobrenome").toString();
      conta = pref.getString("estado").toString();
      telefone = pref.getString("telefone").toString();
    });

    String vall = pref.getString("id")!;
    if (vall == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
    }
  }

  Future Agendamentos() async {

    final urll =
    Uri.parse("https://kulolesaa.000webhostapp.com/adicionar_agenda.php");


      var dados = {
        "para": dropdownValue,
        "servico": "trans",
        "quem": nome + " " +sobrenome,
        "id_serv": widget.id,
        "quemm": meuid,
        "foto": widget.img,
        "preco": widget.preco,
        "user": widget.user,
        "espaco": widget.marca,
        "tel": telefone,

      };

      final sending = await http.post(urll, body: dados);

      final send = jsonDecode(sending.body);


      if (send != "") {

          timerSnackbar(
            context: context,
            contentText: send,
            backgroundColor: Colors.green[500],
            buttonLabel: "",
            afterTimeExecute: () => print("Operation Execute."),
            second: 4,
          );

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 300),
            child: SucessoAG(),
          ),
        );

      }
      else {

        timerSnackbar(
          context: context,
          contentText: send,
          backgroundColor: Colors.blue[700],
          afterTimeExecute: () => print("Operation Execute."),
          second: 4,
        );
    }
  }




  @override
  void initState() {
    super.initState();
    CheckConection();
    GetDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .55,
              width: MediaQuery.of(context).size.width * 1,
              child: Image(
                fit: BoxFit.contain,
                image: CachedNetworkImageProvider(
                  'https://kulolesaa.000webhostapp.com/trans/' + widget.img,
                ),
              ),
            ), //container da foto
            Container(
              margin: EdgeInsets.only(top: 0),
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.marca, textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'pp2',
                        fontSize: 35,
                      ),
                    ),
                  ), //linha onde tem o nome do transporte



                 Container(
                   padding: EdgeInsets.only(top:8,bottom:12, left: 6, right: 6),
                   decoration: BoxDecoration(
                     color: Colors.grey[100],
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: Column(
                     children:
                     <Widget>[
                       Container(
                         margin: EdgeInsets.only(top: 12),
                         child: Row(
                           children: [
                             Text("Lugares: ",
                               style: TextStyle(
                                 color: Colors.grey[600],
                                 fontFamily: 'pp2',
                               ),
                             ),
                             Text(
                               " " + widget.lugares,
                               style: TextStyle(
                                 color: Colors.grey[800],
                                 fontWeight: FontWeight.bold,
                                 fontFamily: 'pp2',
                               ),
                             ),
                           ],
                         ),
                       ), //container lugares

                       Container(
                         margin: EdgeInsets.only(top: 2),
                         child: Row(
                           children: [
                             Text("Partida: ",
                               style: TextStyle(
                                 color: Colors.grey[600],
                                 fontFamily: 'pp2',
                               ),),
                             Text(
                               " " + widget.onde,
                               style: TextStyle(
                                 color: Colors.grey[800],
                                 fontFamily: 'pp2',
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ],
                         ),
                       ), //container ponto de partidatainer lugares

                       Container(
                         margin: EdgeInsets.only(top: 2),
                         child: Row(
                           children: [
                             Text("Chegada: ",
                               style: TextStyle(
                                 color: Colors.grey[600],
                                 fontFamily: 'pp2',
                               ),),
                             Text(
                               " " + widget.para,
                               style: TextStyle(
                                 color: Colors.grey[800],
                                 fontFamily: 'pp2',
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ],
                         ),
                       ), // container ponto de chegadatainer lugares


                       Container(
                         margin: EdgeInsets.only(top: 2),
                         child: Row(
                           children: [
                             Text("Data de partida: ",
                               style: TextStyle(
                                 color: Colors.grey[600],
                                 fontFamily: 'pp2',
                               ),
                             ),
                             Text(
                               "${" " + widget.quando_sai}",
                               style: TextStyle(
                                 color: Colors.grey[800],
                                 fontWeight: FontWeight.bold,
                                 fontFamily: 'pp2',
                               ),
                             ),
                           ],
                         ),
                       ), //Container dos precostainer lugares
                      ],
                   ),
                 ),


                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 20.0),
                    alignment: Alignment.topLeft,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget> [
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text("Indique o numero de lugar a ser reservado:", style: TextStyle(fontFamily: 'pp2', fontSize: 16.0))
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                            child:
                            DropdownButton<String>(
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>['1 Lugar', '2 Lugares', '3 Lugares', '4 Lugares', '5+ Lugares', widget.lugares + ' Lugares']
                                  .map<DropdownMenuItem<String>>((String? value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value!),
                                );
                              }).toList(),
                            )
                            ),

                        ]
                    ),
                  ),//container onde tem a escolha de numeros de lugares a reservar

                ],
              ),
            ),


          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Container(
                child: Row(
                  children: [
                    Text("AOA ", style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: "pp2",
                        fontSize: 15,
                      ),
                    ),
                    Text(" " +widget.preco, style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: "pp2",
                      fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),

              Container(
                width: 200,
                height: 50,
                  child:   ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )
                        ,),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.blue.shade700),
                    ),
                    onPressed: () {
                              Agendamentos();
                    },
                    child: Text(
                      'Agendar',
                      style: TextStyle(color: Colors.white, fontFamily: "pp2", fontSize: 20),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

class Trajeto extends StatefulWidget {
  const Trajeto({Key? key}) : super(key: key);

  @override
  State<Trajeto> createState() => _TrajetoState();
}

class _TrajetoState extends State<Trajeto> {
  TextEditingController busca = new TextEditingController();
  bool process = false;
  bool process2 = false;

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
        second: 8,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.arrow_back,
                color: Colors.black, size: 30.0),
          ),
        ),
        leadingWidth: 35.0,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Text(
          "Onde deseja ir ?",
          style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            fontFamily: "pp2",
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 8.0),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 0.0),
                        child: Image.asset(
                          "assets/banner.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * .50,
                    width: MediaQuery.of(context).size.width * 1,
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .4),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10.0, top: 5.0),
                          child: Text(
                            "Descreva o seu Destino!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "pp2",
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10.0, top: 2.0),
                          child: Text(
                            "Encontre o motorista certo para o seu trajecto. ",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "pp2",
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  "Procure por ponto de chegada",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontFamily: "pp2",
                                  ),
                                ),
                              ),
                              Text(""),
                            ],
                          ),
                        ), // onde tem a parte dos lugares

                        Container(
                          padding: EdgeInsets.only(
                            top: 40.0,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .80,
                            height: 35.0,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: busca,
                              onFieldSubmitted: (val){
                                BuscarTransPort();
                              },
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25.0),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                    top: 0, bottom: 20.0, left: 14.0, right: 5.0),
                                filled: false,
                                hintText: 'Para onde vai?',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontFamily: 'pp2',
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .04,
                              bottom: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: () => BuscarTransPort(),
                              child: process == false
                                  ? Text(
                                      'Buscar ',
                                      style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 20.0,
                                        fontFamily: "pp2",
                                      ),
                                    )
                                  : SizedBox(
                                      height: 30.0,
                                      width: 30.0,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        backgroundColor: Colors.blue[700],
                                      )),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: InkWell(
                            onTap: () => GetAllTrans(),
                            child: process2 == false
                                ? const Text(
                                    "Ver todos os transportes",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "pp2",
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                                : SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      backgroundColor: Colors.blue[700],
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future BuscarTransPort() async {
    setState(() {
      process = true;
    });

    Future.delayed(const Duration(milliseconds: 4000), () {
      setState(() {
        process = false;
      });
    });

    var url = Uri.parse("https://kulolesaa.000webhostapp.com/search_trans.php");
    final text = {
      "text": busca.text,
    };
    final res = await http.post(url, body: text);
    var respostaa = jsonDecode(res.body);
    print(respostaa);

    if (respostaa != null) {
      setState(() {
        process = false;
      });

      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 100),
          child: TransPort(tudo: respostaa),
        ),
      );
    }

    else {
      showDialog (
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Alert Dialog Box"),
          content: const Text("You have raised a Alert Dialog Box"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.all(14),
                child: const Text("okay"),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future GetAllTrans() async {
    setState(() {
      process2 = true;
    });

    var url = Uri.parse("https://kulolesaa.000webhostapp.com/get_trans.php");
    final text = {
      "text": busca.text,
    };
    final res = await http.post(url, body: text);
    var respostaa = jsonDecode(res.body);
    print(respostaa);
    if (respostaa != null) {
      setState(() {
        process2 = false;
      });

      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 100),
          child: TransPort(tudo: respostaa),
        ),
      );
    }
  }
}

class ReservarH extends StatefulWidget {
  var preco,onde, disp, id, quem, foto, espaco, telefone, classificacao, desc;
  ReservarH(
      {this.quem,
      this.id,
      this.disp,
      this.espaco,
      this.preco,
      this.onde,
      this.foto,
      this.desc,
      this.classificacao,
      this.telefone});

  @override
  State<ReservarH> createState() => _ReservarHState();
}

class _ReservarHState extends State<ReservarH> {

  String DataFormatada = "";
  DateTime tgl = new DateTime.now();
  DateTime now = DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);


  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(2022),
        lastDate: DateTime(2050));

    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        if(tgl.isBefore(now)){
              timerSnackbar(
        context: context,
        backgroundColor: Colors.red[500],
        buttonLabel: "",
        contentText: "Escolha uma data a partir de hoje",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100])
        afterTimeExecute: () => print('acionado'),
        second: 8,
      );
        }
        else{
          DataFormatada = new DateFormat.yMEd().format(tgl);
        print(tgl);
        }
        
      });
    } else {}
  }

  String avc = "";
  String nome = "";
  String meuid = "";
  String conta = "";
  String sobrenome = "";
  String telefone = "";

  void GetDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nome = pref.getString("nome").toString();
      meuid = pref.getString("id").toString();
      sobrenome = pref.getString("sobrenome").toString();
      conta = pref.getString("estado").toString();
      telefone = pref.getString("telefone").toString();
    });

    String vall = pref.getString("id")!;
    if (vall == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  bool ActiveConnection = false;
  String T = "";




  Future Reviews() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/get_reviews.php");


    var digitadoo = {
      "id_serv": widget.id,
      "serv": "acomodacaoK",
    };

    final pesquisarr = await http.post(link, body: digitadoo);
    final ress = jsonDecode(pesquisarr.body);
    print(ress);
    return jsonDecode(pesquisarr.body);
  }


  Future AddFavs() async {
    final urll =
    Uri.parse("https://kulolesaa.000webhostapp.com/add_favs.php");


    var dados = {
      "id": widget.id,
      "servico": "acomodacaoK",
      "foto": widget.foto,
      "preco": widget.preco,
      "tipo_servico": widget.espaco,
      "meuid": meuid,
    };

    final sending = await http.post(urll, body: dados);

    final send = jsonDecode(sending.body);

    if(send == "sim"){

      timerSnackbar(
        context: context,
        contentText:  widget.espaco + " adicionado aos favoritos com sucesso",
        backgroundColor: Colors.blue[700],
        buttonLabel: "",
        afterTimeExecute: () => print("Operation Execute."),
        second: 4,
      );

    }
    else {

      timerSnackbar(
        context: context,
        contentText: " Ocorreu um erro ao tentar favoritar " + widget.espaco,
        backgroundColor: Colors.red[400],
        buttonLabel: "",
        afterTimeExecute: () => print("Operation Execute."),
        second: 3,
      );

    }

  }



  Future HowMuchReviw() async {
    final linkk = Uri.parse("https://kulolesaa.000webhostapp.com/how_much_reviews.php");


    var digitadood = {
      "id_serv": widget.id,
      "serv": "acomodacaoK",
    };

    final pesquisarrr = await http.post(linkk, body: digitadood);
    final resss = jsonDecode(pesquisarrr.body);
    print(resss);
    setState(() {
      avc = resss.toString();
    });
  }


  @override
  void initState() {
    super.initState();
    GetDatas();
    Reviews();
    HowMuchReviw();
    //
    // Timer.periodic(Duration(seconds: 20), (timer) {
    //   CheckConection();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 5,
                    height: MediaQuery.of(context).size.height * .68,
                    child: Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        'https://kulolesaa.000webhostapp.com/acomodacaoK/' +
                            widget.foto,
                      ),
                    ),
                  ),
                  Positioned(

                    child: Container(
                      padding: const EdgeInsets.only(top:30.0, left: 12.0, right: 12.0, bottom: 12.0),
                      color: Colors.black38,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                      ),
                      padding: const EdgeInsets.only(top:30.0, left: 12.0, right: 12.0, bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(widget.espaco, style: TextStyle(
                              fontFamily: "pp2",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white38,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  child: Text(avc == '' ? avc + "0 Avaliação" : avc + " Avaliações", style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "pp2"
                                    ),
                                  ),
                                ),
                                FavoriteButton(
                                  isFavorite: false,
                                  iconSize: 30.0,

                                  // iconDisabledColor: Colors.white,
                                  valueChanged:
                                      (_isFavorite) {
                                    if (_isFavorite == true) {

                                      if (_isFavorite == true) {
                                        AddFavs();
                                      } else {
                                        print("removido com sucesso!");
                                      }

                                    } else {
                                      timerSnackbar(
                                        context: context,
                                        backgroundColor:
                                        Colors
                                            .red[300],
                                        contentText:
                                        "Acomodação foi removido dos dos favoritos !",
                                        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
                                        buttonLabel: "",
                                        afterTimeExecute:
                                            () => print(
                                            "Acomodacao removida com sucesso!"),
                                        second: 3,
                                      );
                                    }
                                  },
                                ),
                              ]
                            ),
                          ),
                        ]
                      ),

                    ),
                  ),
                ]
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.star, color: Colors.blue[700]),
                                  Container(
                                    child: Text(widget.classificacao, style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "pp2",
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ), // rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on_outlined, size: 15, color: Colors.blue[700]),
                                    Container(
                                      child: Text(widget.onde, style: TextStyle(
                                          fontSize: 15.0,
                                        fontFamily: "pp2",
                                        color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ), //location pin
                      ],
                    ),

                    Container(
                      child: Row(
                        children: [
                          Text("AOA", style: TextStyle(
                            fontSize: 10.0,
                            fontFamily: "pp2",
                            color: Colors.grey[600],
                          ), ),
                            SizedBox(
                              width: 5,
                            ),
                          Text(widget.preco, style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: "pp2",
                            color: Colors.blue[700],
                          ),
                          ),
                        ],
                      ),
                    ), //termino onde tem o texto dos precos
                  ],
                ),
              ),


              InkWell(
                onTap: () {
                  _selectedDate(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width * .98,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DataFormatada != ""
                      ? Text(DataFormatada.toString(),  style: TextStyle(color: Colors.grey[800], fontSize: 15.0,
                    fontFamily: "pp2",
                   ),)
                      : Text("Escolha a Data", style: TextStyle(color: Colors.grey[800], fontSize: 15.0,
                    fontFamily: "pp2",
                 ),),
                ),
              ), //escolher datas

              SizedBox(
                height: 6,
              ),

              Container(
                child:  Container(
                  margin: EdgeInsets.only(top: 0.0),
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  width: MediaQuery.of(context).size.width * .9,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          )),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.blue.shade700),
                    ),
                    onPressed: () => agendamento(),
                    child: Text(
                      'Reservar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "pp2",
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),

              ),  //botao de reserva

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: Text("Descrição",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontFamily: "pp2",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ), // titulo descricao
              SizedBox(
                height: 10,
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: Text(widget.desc,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontFamily: "pp2",
                    fontWeight: FontWeight.normal,
                  ), ),
              ), // descricao da acomodacao

              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: Divider(
                  thickness: 1,
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 0.0),
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: Text("Avaliações 1",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontFamily: "pp2",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ), // titulo reviews

              // // Reviews Area reserved
              // Container(
              //   alignment: Alignment.topLeft,
              //   height: MediaQuery.of(context).size.height * .7,
              //   margin: EdgeInsets.only(top: 0.0),
              //   padding: EdgeInsets.symmetric(horizontal: 22.0),
              //   child: FutureBuilder(
              //     future: Reviews(),
              //     builder: (
              //         BuildContext context,
              //         AsyncSnapshot snapshot,
              //         ) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return CircularProgressIndicator();
              //       } else if (snapshot.connectionState == ConnectionState.done) {
              //         if (snapshot.hasError) {
              //           return const Text('Error');
              //         } else if (snapshot.hasData) {
              //           return  Container(
              //             width: MediaQuery.of(context).size.width* .9,
              //             child: ListView.builder(
              //                 itemCount: snapshot.data.length,
              //                 itemBuilder: (BuildContext context, int index) {
              //                   var quan = snapshot.data[index]['quando'].split(" ");
              //                   var dates = quan[0].split("-");
              //                   var dia = dates[2];
              //                   var mes = dates[1];
              //
              //                   return Padding(
              //                     padding: const EdgeInsets.symmetric(vertical: 15.0),
              //                     child: ListTile(
              //                       leading: Container(
              //
              //                         child:  ClipRRect(
              //                           borderRadius: BorderRadius.circular(100), // Image border
              //                           child: SizedBox.fromSize(
              //                             size: Size.fromRadius(20), // Image radius
              //                             child: Image(
              //                               image: CachedNetworkImageProvider(
              //                                 'https://kulolesaa.000webhostapp.com/perfil/' +
              //                                     snapshot.data[index]['foto_quem'],
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                       title: Row(
              //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Column(
              //                             crossAxisAlignment: CrossAxisAlignment.start,
              //                             children: [
              //                               Text(snapshot.data[index]['nome'], style: TextStyle(
              //                                 fontWeight: FontWeight.bold,
              //                                 fontFamily: "pp2",
              //                               ),
              //                               ),
              //                               Container(
              //                                 padding: EdgeInsets.symmetric(horizontal: 4),
              //                                 decoration: BoxDecoration(
              //                                   color: Colors.blue[50],
              //                                   borderRadius: BorderRadius.circular(40),
              //                                 ),
              //                                 child: Row(
              //                                     children: <Widget>[
              //                                       snapshot.data[index]['avaliacao'] > 3  ? Icon(Icons.star, size: 20, color: Colors.amber) :  Icon(Icons.star, size: 20, color: Colors.red[600]),
              //                                       Container(
              //                                         child: Text(snapshot.data[index]['avaliacaoacom'], style: TextStyle(
              //                                           color: Colors.grey[700],
              //                                           fontFamily: "pp2",
              //                                         ),),
              //                                       )
              //                                     ]
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                           Text(dia+"/"+mes , style: TextStyle(
              //                             fontFamily: "pp2",
              //                               color: Colors.grey[500],
              //                           ),
              //                           ),
              //                         ],
              //                       ),
              //                       subtitle: Text(snapshot.data[index]['comentario'], style: TextStyle(
              //                         color: Colors.grey[700],
              //                         fontFamily: "pp2",
              //                       ),
              //                       ),
              //                     ),
              //                   );
              //                 }
              //             ),
              //           );
              //         } else {
              //           return const Text('Empty data');
              //         }
              //       } else {
              //         return Text('State: ${snapshot.connectionState}');
              //       }
              //     },
              //   ),
              // ),

              // Reviews Area reserved
              Container(
                height: MediaQuery.of(context).size.height * .5,
                child: FutureBuilder(
                  future: Reviews(),
                  builder: (
                      BuildContext context,
                      AsyncSnapshot snapshot,
                      ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 40,width: 40,
                        child:CircularProgressIndicator()
                      );
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('Ocorreu um erro!');
                      } else if (snapshot.hasData) {
                        return  Container(
                          width: MediaQuery.of(context).size.width* .9,
                          padding: EdgeInsets.only(bottom: 35.0),
                          height: 150.0,
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              
                              itemBuilder: (BuildContext context, int index) {
                                var quan = snapshot.data[index]['quando'].split(" ");
                                var dates = quan[0].split("-");
                                var dia = dates[2];
                                var mes = dates[1];

                                return Container(
                                  margin: EdgeInsets.only(bottom: 15.0),
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      child:  ClipRRect(
                                        borderRadius: BorderRadius.circular(100), // Image border
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(20), // Image radius
                                          child: CachedNetworkImage(
  imageUrl: 'https://kulolesaa.000webhostapp.com/perfil/' +  snapshot.data[index]['foto_quem'],
  placeholder: (context, url) => CircularProgressIndicator(), // Indicador de carregamento enquanto a imagem é buscada na internet
  errorWidget: (context, url, error) => Icon(Icons.error), // Widget a ser exibido em caso de erro ao carregar a imagem
),
                                        ),
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data[index]['nome'], style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "pp2",
                                            ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius: BorderRadius.circular(40),
                                              ),
                                              child: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.star, size: 20, color: Colors.amber),
                                                    Container(
                                                      padding: EdgeInsets.only(right: 4),
                                                      child: Text(snapshot.data[index]['avaliacao'] , style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontFamily: "pp2",
                                                      ),),
                                                    )
                                                  ]
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(dia+"/"+mes , style: TextStyle(
                                          fontFamily: "pp2",
                                          color: Colors.grey[500],
                                        ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(snapshot.data[index]['comentario'], style: TextStyle(
                                      color: Colors.grey[700],
                                      fontFamily: "pp2",
                                    ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        );
                      } else {
                        return const Text('Empty data');
                      }
                    } else {
                      return Text('State: ${snapshot.connectionState}');
                    }
                  },
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  Future agendamento() async {
    final urll =
        Uri.parse("https://kulolesaa.000webhostapp.com/adicionar_agenda.php");

    if(tgl.isAtSameMomentAs(now)){
      timerSnackbar(
        context: context,
        contentText: "Escolha a data!",
        buttonPrefixWidget: Icon(Icons.done_outline),
        afterTimeExecute: () => print("Operation Execute."),
        second: 4,
      );
    }

   else if(tgl==''){
      timerSnackbar(
        context: context,
        contentText: "Escolha a data!",
        buttonPrefixWidget: Icon(Icons.done_outline),
        afterTimeExecute: () => print("Operation Execute."),
        second: 4,
      );
    }
    else {


      var d =  tgl.toString().split(" ");
      var para = d[0];
      var dados = {
        "para": para,
        "servico": "acomodacaoK",
        "quem": nome + " " +sobrenome,
        "id_serv": widget.id,
        "quemm": meuid,
        "foto": widget.foto,
        "preco": widget.preco,
        "user": widget.quem,
        "espaco": widget.espaco,
        "tel": telefone,

      };

      final sending = await http.post(urll, body: dados);

      final send = jsonDecode(sending.body);


      if (send != "") {
        print(tgl);

        timerSnackbar(
          context: context,
          contentText: send,
          backgroundColor: Colors.green[500],
          buttonLabel: "",
          afterTimeExecute: () => print("Operation Execute."),
          second: 4,
        );

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 300),
            child: SucessoAG(),
          ),
        );

      }
      else {
        print(tgl);

        timerSnackbar(
          context: context,
          contentText: send,
          backgroundColor: Colors.blue[700],
          afterTimeExecute: () => print("Operation Execute."),
          second: 4,
        );
      }
    }

  }
}

class Expe extends StatefulWidget {

  Expe({this.prov});

  var prov;

  @override

  State<Expe> createState() => _ExpeState();

}

class _ExpeState extends State<Expe> {
  bool processand = false;
  TextEditingController pesq_text = new TextEditingController();

  Future GetDatas() async {
    var url = Uri.parse("https://kulolesaa.000webhostapp.com/show_exp.php");
    final res = await http.get(url);
    return jsonDecode(res.body);
  }
  String nome = "";
  String id = "";
  String sobrenome = "";
  String estado = "";
  String telefone = "";
  String quando = "";
  String foto = "";

  void GetUserDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("nome")!;
      id = pref.getString("id")!;
      sobrenome = pref.getString("sobrenome")!;
      estado = pref.getString("estado")!;
      telefone = pref.getString("telefone")!;
      quando = pref.getString("quando")!;
      foto = pref.getString("foto")!;
    });

    String val = pref.getString("id")!;
    if (val == "") {

      if(id == "null"){
        Get.to(() => LoginPage());
      }
    }
  }



  @override
  void initState() {
    super.initState();
    GetDatas();
    GetUserDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        height: MediaQuery.of(context).size.height ,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:10.0, right: 10.0, top:30.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                Text('Olá '+ nome.toString(), style: TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: "pp2",
                                ),),

                                Text("Actividades em " + widget.prov, style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: "pp2",
                                ),),
                              ]
                          ),


                          Container(
                            height: 50.0,
                            margin: EdgeInsets.only(bottom: 10.0),
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.blue[300],
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(50.0),
                              child: CachedNetworkImage(
                              imageUrl: 'https://kulolesaa.000webhostapp.com/perfil/' + foto,
                              placeholder: (context, url) => CircularProgressIndicator(), // Indicador de carregamento enquanto a imagem é buscada na internet
                              errorWidget: (context, url, error) => Icon(Icons.error), // Widget a ser exibido em caso de erro ao carregar a imagem
                            ),


                              //Image.network( fit: BoxFit.cover,),

                              /*  Image.network("https://kulolesaa.000webhostapp.com/perfil/img1.png",
                                           fit: BoxFit.cover,),*/
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ), // termino da area de do topo

              SizedBox(
                height: 20,
              ),


              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                margin: EdgeInsets.only(left: 0.0, top: 0.0,  right: 0),
                child:  Row(
                  children: [
                    Text("Em Destaque", style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "pp2",
                        color: Colors.grey[800]
                    ),
                    ),

                    Spacer(),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              duration: Duration(milliseconds: 300),
                              child: HomePage1(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(Icons.home,
                              color: Colors.grey[600], size: 30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ), // termino da parte que fala em destaque

              Container(
                color:Colors.grey[50],
                padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 20.0),
                width: MediaQuery.of(context).size.width * 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 10.0),
                        Stack(

                          children: <Widget>[


                            Container(
                                height: 150,
                                foregroundDecoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10), // Image border
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(110), // Image radius
                                    child: Image.asset('assets/HOT2.jpeg', fit: BoxFit.cover),
                                  ),
                                )
                            ),

                            Positioned(
                              child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black45?.withOpacity(0.3),

                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                        margin: EdgeInsets.only(left: 5, top: 5),
                                        child:  FavoriteButton(
                                          isFavorite: false,
                                          iconSize: 30.0,

                                          // iconDisabledColor: Colors.white,
                                          valueChanged:
                                              (_isFavorite) {
                                            if (_isFavorite == true) {
                                              // if(resposta == 200){
                                              //   timerSnackbar(
                                              //     context: context,
                                              //     backgroundColor:
                                              //     Colors.green[
                                              //     300],
                                              //     contentText:
                                              //     "Acomodação ${dados[index]['espaco']} adicionado aos favoritos !",
                                              //     // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
                                              //     buttonLabel: "",
                                              //     afterTimeExecute:
                                              //         () => print(
                                              //         "Acomodacao adicionada com sucesso!"),
                                              //     second: 2,
                                              //   );
                                              // }

                                            } else {
                                              timerSnackbar(
                                                context: context,
                                                backgroundColor:
                                                Colors
                                                    .red[300],
                                                contentText:
                                                "Acomodação foi removido dos dos favoritos !",
                                                // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
                                                buttonLabel: "",
                                                afterTimeExecute:
                                                    () => print(
                                                    "Acomodacao removida com sucesso!"),
                                                second: 3,
                                              );
                                            }
                                          },
                                        ),

                                      ),
                                    ],
                                  )
                              ),
                            ),

                            Positioned(
                              bottom: 4,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 13),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(Icons.location_on_outlined, color: Colors.white70, size: 12),
                                                    Text("Luanda", style: TextStyle(

                                                      color: Colors.white60,
                                                      fontFamily: "pp2",
                                                      fontSize: 10,
                                                    ),),
                                                  ]
                                              ),

                                              Container(
                                                width:155.0,
                                                margin: EdgeInsets.only(left: 5),
                                                child: Text("Hotel Joao, cijnceciniui",
                                                  overflow: TextOverflow.ellipsis, style: TextStyle(
                                                    fontFamily: "pp2",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              )
                                            ]
                                        ),
                                      ),

                                      Container(
                                        child: Row(

                                            children: <Widget>[
                                              Icon(Icons.star, size: 20, color: Colors.yellow[600]),
                                              Container(
                                                child: Text("4.1", style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "pp2",
                                                ),),
                                              )
                                            ]
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ],
                        ), //elemento do card em anuncio
                        SizedBox(width: 25.0),
                      ],
                    ),
                ),
              ), // termino do scroll horizontal dos destaques

              Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(bottom: 10.0),
                color: Colors.grey[50],
                margin: EdgeInsets.all(0),
                child: FutureBuilder(
                    future: GetDatas(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }

                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                List dados = snapshot.data;
                                return
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 15.0,),
                                    width:
                                    MediaQuery.of(context).size.width * .95,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                        margin: EdgeInsets.only(
                                            top: 0.0, bottom: 10.0),
                                        width:
                                            MediaQuery.of(context).size.width * .95,
                                        height:
                                            MediaQuery.of(context).size.width * .5,
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                          "https://kulolesaa.000webhostapp.com/expe/" +
                                              dados[index]['foto'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                       Container(
                                         margin: EdgeInsets.only(bottom: 5.0),
                                         padding: EdgeInsets.only(bottom: 15.0),
                                         width:
                                         MediaQuery.of(context).size.width * .95,
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                dados[index]['tipo_exp'].toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700],
                                                  fontSize: 25.0,
                                                  fontFamily: "pp2",
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Icon(Icons.location_on_outlined,
                                                      size: 14 , color: Colors.grey[600],),
                                                  Text(
                                                      " ${dados[index]['provincia']}",
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFamily: "pp2",
                                                      fontSize: 14.0,
                                                    ),),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: 0.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("AOA",
                                                        style: TextStyle(
                                                          color: Colors.grey[800],
                                                          fontSize: 8.0,
                                                          fontFamily: "pp2",
                                                        ),
                                                      ),
                                                      Text(
                                                        dados[index]['preco'].toString(),
                                                        style: TextStyle(
                                                          color: Colors.grey[800],
                                                          fontSize: 30.0,
                                                          fontFamily: "pp2",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                6.0),
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              Colors.blue.shade700),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type: PageTransitionType
                                                              .rightToLeft,
                                                          duration: Duration(
                                                              milliseconds: 150),
                                                          child: Agendar(
                                                              id: dados[index]
                                                                  ['id'],
                                                              user: dados[index]
                                                                  ['usuario'],
                                                              tipo: dados[index]
                                                                  ['tipo_exp'],
                                                              telefone: dados[index]
                                                                  ['telefone'],
                                                              foto: dados[index]
                                                                  ['foto'],
                                                              prov: dados[index]
                                                                  ['provincia'],
                                                              descricao:
                                                                  dados[index]
                                                                      ['descricao'],
                                                              preco: dados[index]
                                                                  ['preco']),
                                                        ),
                                                      );
                                                    },
                                                    child: processand == false
                                                        ? Text(
                                                            'Agendar',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'pp2',
                                                                color:
                                                                    Colors.white),
                                                          )
                                                        : SizedBox(
                                                            child: CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Colors.blue
                                                                        .shade700),
                                                            height: 25,
                                                            width: 25,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ],
                                    ),
                                  );
                              })
                          : Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 22.0,
                                            bottom: 10.0,
                                            left: 5.0,
                                            right: 5.0),
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            9,
                                        height: MediaQuery.of(context)
                                                .size
                                                .width *
                                            1.2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          color: Colors.grey[200],
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            .9,
                                        margin: EdgeInsets.only(bottom: 15.0),
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .6,
                                                height: 20.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              alignment: Alignment.topLeft,
                                              child: Row(children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 5.0),
                                                  width: 20,
                                                  height: 20.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .6,
                                                  height: 25.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 20.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(""),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .2,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Agendar extends StatefulWidget  {
  var id, tipo, user, foto, descricao, preco, prov, telefone;

  Agendar(
      {this.id,
      this.tipo,
      this.user,
      this.foto,
      this.descricao,
      this.preco,
      this.telefone,
      this.prov}
      );

  @override
  State<Agendar> createState() => _AgendarState();
}

class _AgendarState extends State<Agendar> {
  bool processand = false;

  String avc = "";

  Future Reviews() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/get_reviews.php");


    var digitadoo = {
      "id_serv": widget.id,
      "serv": 'expe',
    };

    final pesquisarr = await http.post(link, body: digitadoo);
    final ress = jsonDecode(pesquisarr.body);
    print(ress);
    return jsonDecode(pesquisarr.body);
  }


  Future HowMuchReviw() async {
    final linkk = Uri.parse("https://kulolesaa.000webhostapp.com/how_much_reviews.php");


    var digitadood = {
      "id_serv": widget.id,
      "serv": "expe",
    };

    final pesquisarrr = await http.post(linkk, body: digitadood);
    final resss = jsonDecode(pesquisarrr.body);
    print(resss);
    setState(() {
      avc = resss.toString();
    });
  }


  String DataFormatada = "";
  DateTime tgl = new DateTime.now();
  DateTime now = DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);


  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(2022),
        lastDate: DateTime(2050));

    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        if(tgl.isBefore(now)){
          timerSnackbar(
            context: context,
            backgroundColor: Colors.red[500],
            contentText: "Escolha uma data a partir de hoje",
            // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
            buttonLabel: "",
            afterTimeExecute: () => print('acionado'),
            second: 8,
          );
        }
        else{
          DataFormatada = new DateFormat.yMEd().format(tgl);
          print(tgl);
        }

      });
    } else {}
  }



  String id = "";
  String nome = "";
  String sobrenome = "";
  String estado = "";
  String foto = "";
  String nascimento = "";
  String email = "";
  String telefone = "";

  void todosDados() async {
    SharedPreferences dados = await SharedPreferences.getInstance();

    setState(() {
      nome = dados.getString("nome").toString();
      sobrenome = dados.getString("sobrenome").toString();
      id = dados.getString("id").toString();
      telefone = dados.getString("telefone").toString();
      email = dados.getString("email").toString();
      nascimento = dados.getString("quando").toString();
      foto = dados.getString("foto").toString();
      estado = dados.getString("estado").toString();
    });

    if(id == "null"){
      Get.to(() => MyHomePage());
    }
  }


  Future AddFavs() async {
    final urll =
    Uri.parse("https://kulolesaa.000webhostapp.com/add_favs.php");


      var dados = {
        "id": widget.id,
        "servico": "expe",
        "foto": widget.foto,
        "preco": widget.preco,
        "tipo_servico": widget.tipo,
        "meuid": id,
      };

      final sending = await http.post(urll, body: dados);

      final send = jsonDecode(sending.body);

      if(send == "sim"){

        timerSnackbar(
          context: context,
          contentText:  widget.tipo + " adicionado aos favoritos com sucesso",
          backgroundColor: Colors.blue[700],
          buttonLabel: "",
          afterTimeExecute: () => print("Operation Execute."),
          second:4,
        );

      }
      else {

        timerSnackbar(
          context: context,
          contentText: " Ocorreu um erro ao tentar favoritar " + widget.tipo,
          backgroundColor: Colors.red[400],
          buttonLabel: "",
          afterTimeExecute: () => print("Operation Execute."),
          second: 4,
        );

      }

  }


  Future AddAgendaExpe() async {
    final urll =
    Uri.parse("https://kulolesaa.000webhostapp.com/adicionar_agenda.php");

    if(tgl.isAtSameMomentAs(now)){
      timerSnackbar(
        context: context,
        contentText: "Escolha a data!",
        buttonPrefixWidget: Icon(Icons.done_outline),
        afterTimeExecute: () => print("Operation Execute."),
        second: 4,
      );
    }
    else {

      var d =  tgl.toString().split(" ");
      var para = d[0];
      var dados = {
        "id": widget.id,
        "para": tgl,
        "servico": "expe",
        "quem": nome + " " + sobrenome,
        "foto": widget.foto,
        "preco": widget.preco,
        "espaco": widget.tipo,
        "para": para,
        "quemm": id,
        "user": widget.user,
        "tel": telefone,
      };

      final sending = await http.post(urll, body: dados);

      final send = jsonDecode(sending.body);


      if (send != "") {
        print(tgl);

        timerSnackbar(
          context: context,
          contentText: send,
          backgroundColor: Colors.green[200],
          afterTimeExecute: () => print("Operation Execute."),
          second: 4,
        );

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 300),
            child: SucessoAG(),
          ),
        );

      }
      else {
        print(tgl);

        timerSnackbar(
          context: context,
          contentText: send,
          afterTimeExecute: () => print("Operation Execute."),
          second: 4,
        );
      }
    }

  }

  @override
  void initState() {
    super.initState();
    HowMuchReviw();
    Reviews();
    todosDados();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
                    children: [
                      Stack(
                        children: <Widget> [
                          Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * .6,
                          child: Image(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                'https://kulolesaa.000webhostapp.com/expe/${widget.foto}',
                            ),
                          ),
                        ),

                          Positioned(
                            bottom: 5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                color: Colors.black38,
                              ),
                              padding: const EdgeInsets.only(top:20.0, left: 12.0, right: 12.0, bottom: 12.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Container(
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white38,
                                                borderRadius: BorderRadius.circular(40),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              child: Text(avc  == "" ? "0 Avaliação" : avc + " Avaliações", style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "pp2"
                                              )),
                                            ),
                                            FavoriteButton(
                                              isFavorite: false,
                                              iconSize: 30.0,

                                              // iconDisabledColor: Colors.white,
                                              valueChanged:
                                                  (_isFavorite) {
                                                if (_isFavorite == true) {
                                                  AddFavs();
                                                } else {
                                                  print("removido com sucesso!");
                                                }
                                              },
                                            ),
                                          ]
                                      ),
                                    ),
                                  ]
                              ),

                            ),
                          ),
                        ]
                      ), //container onde tem a imagem
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                        child: Text(
                          widget.tipo.toString(),
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            fontFamily: "pp2",
                          ),
                        ),
                      ), //container onde tem o nome da actividade
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0.0),
                        alignment: Alignment.topLeft,
                        child: Text("${widget.descricao} ", style: TextStyle(color: Colors.grey[700], fontFamily: "pp2") ),
                      ),
                      //container onde tem a descricao da actividade

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0.0),
                        alignment: Alignment.topLeft,
                        child: Text("Marque a data:", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontFamily: "pp2") ),
                      ), //container onde tem a descricao da actividade


                      Container(
                        margin: EdgeInsets.only(top: 6),
                        width: MediaQuery.of(context).size.width * .92,
                        padding: EdgeInsets.symmetric(vertical: 12),

                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: InkWell(
                            onTap: () => _selectedDate(context),
                            child:  DataFormatada != ""
                                ? Text(DataFormatada.toString(), textAlign: TextAlign.center,  style: TextStyle(color: Colors.grey[800], fontSize: 15.0,
                              fontFamily: "pp2",
                            ),)
                                : Text("Escolha a Data", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800], fontSize: 15.0,
                              fontFamily: "pp2",
                            ),),
                        ),
                      ),

                      SizedBox(
                        height: 25,
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 0.0),
                        padding: EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text("Avaliações ",
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20,
                            fontFamily: "pp2",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ), // titulo reviews

                      // Reviews Area reserved
                      Container(
                        height: MediaQuery.of(context).size.height* .4,
                        child: FutureBuilder(
                          future: Reviews(),
                          builder: (
                              BuildContext context,
                              AsyncSnapshot snapshot,
                              ) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                height: 40.0,
                                width: 40.0,
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                return  Container(
                                  width: MediaQuery.of(context).size.width* .9,
                                  padding: EdgeInsets.only(bottom: 35.0),
                                  height: 150.0,
                                  child: ListView.builder(

                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        var quan = snapshot.data[index]['quando'].split(" ");
                                        var dates = quan[0].split("-");
                                        var dia = dates[2];
                                        var mes = dates[1];

                                        return Container(
                                          margin: EdgeInsets.only(bottom: 15.0),
                                          padding: EdgeInsets.symmetric(vertical: 5.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            leading: Container(
                                              child:  ClipRRect(
                                                borderRadius: BorderRadius.circular(100), // Image border
                                                child: SizedBox.fromSize(
                                                  size: Size.fromRadius(20), // Image radius
                                                  child: CachedNetworkImage(
  imageUrl: 'https://kulolesaa.000webhostapp.com/perfil/' + snapshot.data[index]['foto_quem'],
  placeholder: (context, url) => CircularProgressIndicator(), // Indicador de carregamento enquanto a imagem é buscada na internet
  errorWidget: (context, url, error) => Icon(Icons.error), // Widget a ser exibido em caso de erro ao carregar a imagem
),

                                                ),
                                              ),
                                            ),
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(snapshot.data[index]['nome'], style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "pp2",
                                                    ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue[50],
                                                        borderRadius: BorderRadius.circular(40),
                                                      ),
                                                      child: Row(
                                                          children: <Widget>[
                                                               Icon(Icons.star, size: 20, color: Colors.amber),
                                                            Container(
                                                              padding: EdgeInsets.only(right: 4),
                                                              child: Text(snapshot.data[index]['avaliacao'] , style: TextStyle(
                                                                color: Colors.grey[700],
                                                                fontFamily: "pp2",
                                                              ),),
                                                            )
                                                          ]
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(dia+"/"+mes , style: TextStyle(
                                                  fontFamily: "pp2",
                                                  color: Colors.grey[500],
                                                ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(snapshot.data[index]['comentario'], style: TextStyle(
                                              color: Colors.grey[700],
                                              fontFamily: "pp2",
                                            ),
                                            ),
                                          ),
                                        );
                                      }
                                  ),
                                );
                              } else {
                                return const Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        ),
                      ),


                    ],
                  ),


          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Container(
                child: Row(
                  children: [
                    Text("AOA ", style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: "pp2",
                      fontSize: 10,
                    ),
                    ),
                    Text(" " +widget.preco, style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: "pp2",
                      fontSize: 30,
                    ),
                    ),
                  ],
                ),
              ),
              Spacer(),

              Container(
                width: 200,
                height: 50,
                child:   ElevatedButton(

                  style: ButtonStyle(

                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                      ,),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.blue.shade700),
                  ),
                  onPressed: () {
                    AddAgendaExpe();
                  },
                  child: Text(
                    'Reservar',
                    style: TextStyle(color: Colors.white, fontFamily: "pp2", fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Future Msg() async {
    setState(() {
      processand == true;
    });
  }
}


class SucessoAG extends StatefulWidget {
  const SucessoAG({Key? key}) : super(key: key);

  @override
  State<SucessoAG> createState() => _SucessoAGState();
}

class _SucessoAGState extends State<SucessoAG> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[700],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 140.0,
            ),
            Center(
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  child: Icon(Icons.check_circle_outline_sharp, color: Colors.white, size: 130)
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(

                    child: Text("Seu agendamento foi submetido com sucesso!", textAlign: TextAlign.center, style: TextStyle(
                      color: Colors.white,
                      fontFamily: "pp2",
                      fontSize: 20,
                    ),)
                )
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
            ),
            Container(
              child: SizedBox(
                height: 50.0,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomePage1(),
                      ),
                    );
                  },
                  child: Text(
                    'Ir para pagina inicial',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                    ),
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }
}



class SucessoAG3 extends StatefulWidget {
  const SucessoAG3({Key? key}) : super(key: key);

  @override
  State<SucessoAG3> createState() => _SucessoAG3State();
}

class _SucessoAG3State extends State<SucessoAG3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[700],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 140.0,
            ),
            Center(
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  child: Icon(Icons.check_circle_outline_sharp, color: Colors.white, size: 130)
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(

                    child: Text("Seu pedido de alteração de conta foi submetido com sucesso!\nReceberá uma notificação quando o seu pedido for aprovada", textAlign: TextAlign.center, style: TextStyle(
                      color: Colors.white,
                      fontFamily: "pp2",
                      fontSize: 20,
                    ),)
                )
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
            ),
            Container(
              child: SizedBox(
                height: 50.0,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomePage1(),
                      ),
                    );
                  },
                  child: Text(
                    'Ir para pagina inicial',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                    ),
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }
}



class SucessoAG2 extends StatefulWidget {
  const SucessoAG2({Key? key}) : super(key: key);

  @override
  State<SucessoAG2> createState() => _SucessoAG2State();
}

class _SucessoAG2State extends State<SucessoAG2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[700],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 140.0,
            ),
            Center(
              child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  child: Icon(Icons.check_circle_outline_sharp, color: Colors.white, size: 130)
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(

                    child: Text("Sua avaliação foi submetida com sucesso!", textAlign: TextAlign.center, style: TextStyle(
                      color: Colors.white,
                      fontFamily: "pp2",
                      fontSize: 20,
                    ),)
                )
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
            ),
            Container(
              child: SizedBox(
                height: 50.0,
                width: MediaQuery.of(context).size.width * .9,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomePage1(),
                      ),
                    );
                  },
                  child: Text(
                    'Ir para pagina inicial',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                    ),
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }
}
