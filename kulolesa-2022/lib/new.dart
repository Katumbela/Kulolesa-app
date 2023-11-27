import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:image_network/image_network.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timer_snackbar/timer_snackbar.dart';

import 'PaginaUm.dart';

class SearchBarr extends StatefulWidget {

  @override
  State createState() {
    return _SearchBar();
  }
}

class _SearchBar extends State {
  late bool searching, error;
  var data;
  String searchstring = "*";
  TextEditingController pesquisa = new TextEditingController(text: "");
  late String query;

  get tabela => null;
  Future getProjectDetails() async {
    var result = await http
        .get(Uri.parse('https://kulolesaa.000webhostapp.com/pesquisa.php'));
    return result;
  }

  var dataurl = Uri.parse("https://kulolesaa.000webhostapp.com/pesquisa.php");

  @override
  void initState() {
    super.initState();
    error = false;

      CheckConection();

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
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("Operation Execute."),
        second: 8,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
             Navigator.pop(context);
            },
          ),

          bottom: TabBar(tabs: [
            Tab(text: "Acomodação"),
            Tab(text: "Transportes"),
            Tab(text: "Actividades"),
          ]),
          //if searching is true then show arrow back else play arrow
          title: searchField(),
          backgroundColor: Colors.blue[700],
          //if searching set background to orange, else set to deep orange
        ),
        body: TabBarView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: FutureBuilder(
              future: Resultados(),
              builder: (context, AsyncSnapshot snapshot) {
                if(snapshot.hasError){
                  return Text("Erro ao fazer pesquisa!");
                }

                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List dados = snapshot.data;
                        return snapshot.data![index]["descricao"]
                            .contains(searchstring)
                            ? InkWell(
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
                                    'disponivel']
                                        .toString(),
                                  preco: dados[index]
                                  ['preco'].toString(),
                                  desc: dados[index]
                                  ['descricao'].toString(),
                                )
                              ),
                            );
                          },
                          child: ListTile(
                            title: Container(
                              width: MediaQuery.of(context).size.width * .9,
                              height: MediaQuery.of(context).size.height * .5,
                              margin:
                              EdgeInsets.only(top: 15.0, bottom: 10.0),
                              child: Image(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  'https://kulolesaa.000webhostapp.com/acomodacaoK/${dados[index]['foto']}',
                                ),
                              ),
                              // child: ImageNetwork(
                              //   image:
                              //       'https://kulolesaa.000webhostapp.com/acomodacaoK/${dados[index]['foto']}',
                              //   duration: 300,
                              //   width: MediaQuery.of(context).size.width,
                              //   height: MediaQuery.of(context).size.height,
                              //   curve: Curves.easeIn,
                              //   onPointer: true,
                              //   debugPrint: false,
                              //   fullScreen: false,
                              //   fitAndroidIos: BoxFit.cover,
                              //   fitWeb: BoxFitWeb.cover,
                              //   onLoading: const CircularProgressIndicator(
                              //     color: Colors.blue,
                              //   ),
                              //   onError: const Icon(
                              //     Icons.error,
                              //     color: Colors.red,
                              //   ),
                              //   borderRadius: BorderRadius.circular(10),
                              // ),

                              //Image.network( fit: BoxFit.cover,),

                              // child: Image.network('http://gokside.myartsonline.com/acomodacaoK/img2.jpeg',),
                            ),
                            subtitle: Container(
                              margin: EdgeInsets.only(bottom: 15.0),
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      dados[index]['espaco'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.blue,
                                        fontFamily: "pp2",
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(dados[index]['descricao']
                                          .toString())),
                                  Container(
                                      margin: EdgeInsets.only(top: 8.0),
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.place_outlined,
                                            size: 18.0,
                                          ),
                                          Text(
                                              " - ${dados[index]['localizacao']}"),
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.monetization_on_outlined,
                                            size: 18.0,
                                          ),
                                          Text(" - ${dados[index]['preco']}"),
                                        ],
                                      )),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.event_available,
                                            size: 18.0,
                                          ),
                                          Text(
                                              " - Disponível: ${dados[index]['disponivel']}"),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
                            : Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue[700],
                              backgroundColor: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else {
                    return Positioned(
                        child: Center(
                            child: Text("Pesquise por uma acomodação"),
                        ),
                    );
                  }

              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: FutureBuilder(
              future: Resultados2(),
              builder: (context, AsyncSnapshot snapshot) {

                  return snapshot.hasData ?
                  ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List dados2 = snapshot.data;


                        return snapshot.data![index]["marca"]
                            .toString()
                            .contains(searchstring)
                            ? ListTile(
                          title: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * .9,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .5,
                            margin:
                            EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child: Container(
                              child: Image(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  'https://kulolesaa.000webhostapp.com/trans/' +
                                      dados2[index]['foto_carro']
                                          .toString(),
                                ),
                              ),
                            ),

                            //Image.network( fit: BoxFit.cover,),

                            // child: Image.network('http://gokside.myartsonline.com/acomodacaoK/img2.jpeg',),
                          ),
                          subtitle: Container(
                            margin: EdgeInsets.only(bottom: 15.0),
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    dados2[index]['marca'].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                      color: Colors.blue,
                                      fontFamily: "pp2",
                                    ),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(dados2[index]['descricao']
                                        .toString())),
                                Container(
                                    margin: EdgeInsets.only(top: 8.0),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.place_outlined,
                                          size: 18.0,
                                        ),
                                        Text(
                                            " - ${dados2[index]['localizacao']}"),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        )
                            :  Container(
                          child: Text("Pesquise por uma acomodação!")
                          );
                      },
                    ): Text("Nenhum resultado encontrado");


                }

            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: FutureBuilder(
              future: Resultados3(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List dados = snapshot.data;

                      return snapshot.data[index]["descricao"]
                              .toString()
                              .contains(searchstring)
                          ? ListTile(
                              title: Container(
                                width: MediaQuery.of(context).size.width * .9,
                                height: MediaQuery.of(context).size.height * .5,
                                margin:
                                    EdgeInsets.only(top: 15.0, bottom: 10.0),
                                child: Container(
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      'https://kulolesaa.000webhostapp.com/expe/${dados[index]['foto']}',
                                    )
                                  ),
                                ),

                                //Image.network( fit: BoxFit.cover,),

                                // child: Image.network('http://gokside.myartsonline.com/acomodacaoK/img2.jpeg',),
                              ),
                              subtitle: Container(
                                margin: EdgeInsets.only(bottom: 15.0),
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        dados[index]['tipo_exp'].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0,
                                          color: Colors.blue,
                                          fontFamily: "pp2",
                                        ),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(dados[index]['descricao']
                                            .toString())),
                                    Container(
                                      margin: const EdgeInsets.only(top: 8.0),
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.place_outlined,
                                            size: 18.0,
                                          ),
                                          Text(
                                              " - ${dados[index]['localizacao']}"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue[700],
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            );
                    },
                  );
                } else {
                  return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 1.0, vertical: 20),
                      child: const Center(child: Text("Faça uma pesquisa")));
                }

                /**/
              },
            ),
          ),
        ]),
      ),
    );
  }

  Future Resultados() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/pesquisa.php");

    var digitado = {
      "query": pesquisa.text,
      "tabela": "acom",
    };

    final pesquisar = await http.post(link, body: digitado);


    var vari = jsonDecode(pesquisar.body);
    if(vari != null){
      return jsonDecode(pesquisar.body);
    }

    throw Exception("Nenhum resultado encontrado!");

  }

  Future Resultados2() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/pesquisa.php");
    var digitado = {
      "query": pesquisa.text,
      "tabela": "transportes",
    };

    final pesquisar = await http.post(link, body: digitado);
      var vari = jsonDecode(pesquisar.body);
    if(vari != null){
      return jsonDecode(pesquisar.body);
    }

    throw Exception("Nenhum resultado encontrado!");
  }

  Future Resultados3() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/pesquisa.php");

    var digitado = {
      "query": pesquisa.text,
      "tabela": "exp_kulolesa",
    };

    final pesquisar = await http.post(link, body: digitado);
    final res = jsonDecode(pesquisar.body);

    if(res != null){
      return jsonDecode(pesquisar.body);
    }

    throw Exception("Nenhum resultado encontrado!");


  }

  Widget searchField() {
    //search input field
    return Container(
      child: TextField(
        controller: pesquisa,
        autofocus: true,
        onChanged: (value) {
          setState(() {
            searchstring = value;
          });
        },
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.white, fontSize: 18),
          hintText: "Pesquisar Serviços",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ), //under line border, set OutlineInputBorder() for all side border
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ), // focused border color
        ), //de
      ),
    );
  }
}
