import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulolesaa/aaaa.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_snackbar/timer_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'PaginaUm.dart';
import 'main.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbols.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'login.dart';

class Perfil extends StatefulWidget {
  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override


 String userPhotoUrl = '';

  Future<void> fetchUserPhoto() async {
    try {
      final photoUrl = await getUserPhoto('userId');
      setState(() {
        userPhotoUrl = photoUrl;
      });
    } catch (e) {
      // Trate qualquer erro de forma adequada
      print('Erro ao obter a foto do usuário: $e');
    }
  }

  Future<String> getUserPhoto(String userId) async {
    final url = 'https://kulolesaa.000webhostapp.com/get_pic_profile.php?id=$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Erro ao obter foto do usuário');
      }
    } catch (e) {
      throw Exception('Erro de conexão');
    }
  }
  


  void initState() {
    super.initState();
    GetDatas();
      CheckConection();
    fetchUserPhoto();
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

  String nome = "";
  String id = "";
  String estado = "";
  String foto = "";
  String sobrenome = "";
  String quando = "";

  void GetDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("nome").toString();
      foto = pref.getString("foto").toString();
      id = pref.getString("id").toString();
      estado = pref.getString("estado").toString();
      sobrenome = pref.getString("sobrenome").toString();
      quando = pref.getString("quando").toString();
    });

    String val = pref.getString("id").toString();
    if (val == "") {

      if(id == "null"){
        Get.to(() => LoginPage());
      }
    }
  }

  Future<String> todosDados() async {
    SharedPreferences dados = await SharedPreferences.getInstance();

    var tudo = dados.getString("tudo").toString();

    return tudo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 240.0,
                  padding: EdgeInsets.only(top: 5.0, left: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0, top: 25.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 80.0,
                        margin: EdgeInsets.only(bottom: 10.0),
                        width: 80.0,
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child:  ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    "https://kulolesaa.000webhostapp.com/perfil/$foto" ,
                  ),
                ),
                


                          //Image.network( fit: BoxFit.cover,),

                          /*  Image.network("https://kulolesaa.000webhostapp.com/perfil/img1.png",
                                         fit: BoxFit.cover,),*/
                        ),

                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0.0),
                        child: Text(
                          nome + " " + sobrenome,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: "pp2",
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          estado,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.white,
                            fontFamily: "pp2",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:5.0),
                        child:  estado == 'Usuari' ? Text("") : InkWell(

                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 200),
                                child: MyServices(),
                              ),
                            );
                          },

                          child: Text("Meus Serviços",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: Colors.white,
                              fontFamily: "pp2", decoration: TextDecoration.underline
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //TABS AREA, SPECIFIED FOR OR ONLY FOR THE TABS

                Container(
                  margin: EdgeInsets.only(top: 240.0),
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: TabsInfoState(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//funcao para a barra de navegaçcao dos tabs

class TabsInfoState extends StatefulWidget {
  @override
  _TabsInfoState createState() => _TabsInfoState();
}

class _TabsInfoState extends State<TabsInfoState>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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





  String nome = "";
  String id = "";
  String estado = "";
  String sobrenome = "";
  String quando = "";

  void GetDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("nome").toString();
      id = pref.getString("id").toString();
      estado = pref.getString("estado").toString();
      sobrenome = pref.getString("sobrenome").toString();
      quando = pref.getString("quando").toString();
    });

    String val = pref.getString("id").toString();
    if (val == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  List<Map> agenda = [] ;

  Future GetAgendamentos() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/agendamentos.php");


    var digitado = {
      "meu_id": id,
    };

    final pesquisar = await http.post(link, body: digitado);
    final res = jsonDecode(pesquisar.body);
    print(res);
    return jsonDecode(pesquisar.body);
  }

  Future GetNotifications() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/notify.php");


    var digitado = {
      "estado": estado,
    };

    final pesquisar = await http.post(link, body: digitado);
    final res = jsonDecode(pesquisar.body);
    print(res);
    return jsonDecode(pesquisar.body);
  }

  @override
  void initState() {
    super.initState();
    GetAgendamentos();
    GetDatas();
      CheckConection();

    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.blue.shade700,
            labelStyle: TextStyle( fontFamily: "pp2",),
            tabs: [
              Tab(
                text: 'Notificações',
              ),
              Tab(
                text: 'Agendamentos',
              )
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(

            child: TabBarView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: Container(
                    //Text('${agenda.toString()}'),
                    child: Container(
                      child: FutureBuilder(
                        future: GetNotifications(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.data != null) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                List dados = snapshot.data;
                                return  Container(
                                  margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.all(Radius.circular(9.0)),

                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(2),

                                    leading: ClipOval(
                                      child: Image(
                                        width:55,
                                        height: 600,
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          'https://kulolesaa.000webhostapp.com/notify/${dados[index]['icone']}',
                                        ),
                                      ),

                                    ),
                                    title: Container(
                                      margin: EdgeInsets.symmetric(vertical: 15.0),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              dados[index]['quem'].toString() == 'admin' ? "Kulolesa App" : dados[index]['quem'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                                color: Colors.grey[700],
                                                fontFamily: "pp2",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    subtitle: Container(
                                      child: Text(dados[index]['texto'].toString(), style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: "pp2",
                                      )),
                                    ),

                                  ),
                                );

                              },
                            );
                          } else {
                            return Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 1.0, vertical: 20),
                                child: Center(child: Text("Não fez ainda nenhuma reserva!", style: TextStyle( fontFamily: "pp2",))));
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Container(
                    //Text('${agenda.toString()}'),
                    child: Container(
                      child: FutureBuilder(
                        future: GetAgendamentos(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.data != null) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                List dados = snapshot.data;
                                var id = dados[index]['id_servico'];
                                var quem = dados[index]['quem'];
                                var servico = dados[index]['obs'];
                                var para = dados[index]['para'];
                                var quando = dados[index]['quando'];
                                var foto = dados[index]['foto'];
                                var preco = dados[index]['preco'];
                                var espaco = dados[index]['espaco'];

                                return  Container(
                                  margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.all(Radius.circular(9.0)),

                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image(
                                          width:60,
                                          height: 700,
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            'https://kulolesaa.000webhostapp.com/${servico}/${dados[index]['foto']}',
                                          ),
                                        ),

                                      ),
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5.0),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              dados[index]['espaco'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                                color: Colors.black,
                                                fontFamily: "pp2",
                                              ),
                                            ),
                                          ),

                                          Container(
                                              margin: EdgeInsets.only(top: 2),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "AOA",
                                                   style: TextStyle(
                                                     fontSize: 13.0,fontFamily: "pp2",
                                                   ),
                                                  ),
                                                  Text(" - ${dados[index]['preco']}", style: TextStyle(
                                                    fontFamily: "pp2",
                                                  )),
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(top: 0),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Para",
                                                    style: TextStyle(
                                                      fontFamily: "pp2",
                                                    ),
                                                  ),
                                                  Text(
                                                      ": ${dados[index]['para']}", style: TextStyle(
                                                    fontFamily: "pp2",
                                                  )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                      child: Column(
                                        children: [
                                           InkWell(
                                            onTap: () {

                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.rightToLeft,
                                                  duration: Duration(milliseconds: 100),
                                                  child: Review(id: id, servico: servico, espaco: espaco, preco: preco, foto: foto, quando: quando, para: para, quem: quem),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[600],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text("Avaliar", style: TextStyle(
                                                fontFamily: "pp2",
                                                color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),

                                          InkWell(
                                            onTap: () {

                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.rightToLeft,
                                                  duration: Duration(milliseconds: 100),
                                                  child: Ver(id: id, servico: servico, espaco: espaco, preco: preco, foto: foto, quando: quando, para: para, quem: quem),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[600],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text("Ver", style: TextStyle(
                                                fontFamily: "pp2",
                                                color: Colors.white,

                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              },
                            );
                          } else {
                            return Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 1.0, vertical: 20),
                                child: Center(child: Text("Não fez ainda nenhuma reserva!")));
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}


class Ver extends StatefulWidget {
  var preco,para, quando, servico, id, quem, foto, espaco;
  Ver(
      {this.quem,
        this.id,
        this.servico,
        this.espaco,
        this.preco,
        this.para,
        this.foto,
        this.quando,
      });

  @override
  State<Ver> createState() => _VerState();
}

class _VerState extends State<Ver> {

  var dia, mes, ano, hora, min = "";

  @override
  void initState() {

    var quan = widget.quando.split(" ");
    var dates = quan[0].split("-");
    var Hours = quan[1].split(":");

    setState(() {
      dia = dates[2];
      mes = dates[1];
      ano = dates[0];
      hora = Hours[0];
      min = Hours[1];
    });

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 5,
                        height: MediaQuery.of(context).size.height * .68,
                        child: Image(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            'https://kulolesaa.000webhostapp.com/'+widget.servico+'/' +
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
                                  ),
                                  ),
                                ),

                              ]
                          ),

                        ),
                      ),
                    ]
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    child: Text("Agendado para: " + widget.para, style: TextStyle(
                      fontFamily: "pp2",
                      fontSize: 23,
                      color: Colors.black,
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    child: Text("Efectuou este agendamento no dia " + dia + " de ${mes} de ${ano}, as ${hora}h:${min}min", style: TextStyle(
                      fontFamily: "pp2",
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),),
                  ),
                ),


                Container(
                  margin:EdgeInsets.only(top: 30.0, left: 15, right: 15, bottom: 15.0),

                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text('Já usufruiu este serviço ?', style: TextStyle(fontFamily: 'pp2', fontSize: 16.0, ))
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text('Como foi sua experiência ? avalie.', style: TextStyle(fontFamily: 'pp2', fontSize: 14.0, ))
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 100),
                                child: Review(id: widget.id, servico: widget.servico, espaco: widget.espaco, preco: widget.preco, foto: widget.foto, quando: widget.quando, para: widget.para, quem: widget.quem),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("Avaliar", style: TextStyle(
                              fontFamily: "pp2",
                              color: Colors.white,
                            ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}


class VerAdmin extends StatefulWidget {
  var preco, para, quando, servico, id, disp, desc, user,  local, foto, espaco;

  VerAdmin(
      {
        this.user,
        this.id,
        this.servico,
        this.espaco,
        this.preco,
        this.para,
        this.foto,
        this.desc,
        this.local,
        this.disp,
        this.quando,
      }
      );

  @override
  State<VerAdmin> createState() => _VerAdminState();
}

class _VerAdminState extends State<VerAdmin> {

  Future GetAgendamentos() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/agenda_servs.php");


    var digitado = {
      "meu_id": id,
      "serv": widget.servico,
      "id_serv": widget.id,
    };

    final pesquisar = await http.post(link, body: digitado);
    final res = jsonDecode(pesquisar.body);
    print(res);
    return jsonDecode(pesquisar.body);
  }

  String nome = "";
  String id = "";
  String estado = "";
  String sobrenome = "";
  String quando = "";

  void GetDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("nome").toString();
      id = pref.getString("id").toString();
      estado = pref.getString("estado").toString();
      sobrenome = pref.getString("sobrenome").toString();
      quando = pref.getString("quando").toString();
    });

    String val = pref.getString("id").toString();
    if (val == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
    }
  }

  String avc = "";

  Future HowMuchReviews() async {
    final linkk = Uri.parse("https://kulolesaa.000webhostapp.com/how_much_reviews.php");


    var digitadood = {
      "id_serv": widget.id,
      "serv": widget.servico,
    };

    final pesquisarrr = await http.post(linkk, body: digitadood);
    final resss = jsonDecode(pesquisarrr.body);
    print(resss);
    setState(() {
      avc = resss.toString();
    });
  }

  Future Reviews() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/get_reviews.php");


    var digitadoo = {
      "id_serv": widget.id,
      "serv": widget.servico,
    };

    final pesquisarr = await http.post(link, body: digitadoo);
    final ress = jsonDecode(pesquisarr.body);
    print(ress);
    return jsonDecode(pesquisarr.body);
  }


  @override
  void initState() {
    super.initState();
    GetAgendamentos();
    GetDatas();
    Reviews();
    HowMuchReviews();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 5,
                      height: MediaQuery.of(context).size.height * .68,
                      child: Image(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          'https://kulolesaa.000webhostapp.com/'+widget.servico+'/' +
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
                                ),
                                ),
                              ),

                            ]
                        ),

                      ),
                    ),
                  ]
              ), //stack da imagem do servico

              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Container(
                  child: Text("De  "+widget.quando, style: TextStyle(
                    fontFamily: "pp2",
                    fontSize: 23,
                    color: Colors.black,
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Container(
                  child: Text("Preço  "+widget.preco + " Kz", style: TextStyle(
                    fontFamily: "pp2",
                    fontSize: 23,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Container(
                  child: Text( widget.desc, style: TextStyle(
                    fontFamily: "pp2",
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 10.0),
                child:  widget.servico == 'trans' ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    child: Text( 'Ponto de Chegada: ' + widget.local, style: TextStyle(
                      fontFamily: "pp2",
                      fontSize: 16,
                      color: Colors.black,
                    ),),
                  ),
                ) : Text(""),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: widget.servico == "expe" ?
                Row(
                  children: <Widget>[
                    Text("Cat.: ", style: TextStyle( fontSize: 20.0, fontFamily: 'pp2')),
                    Text("ACTIVIDADES ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, fontFamily: 'pp2')),
                  ],
                ) : widget.servico == "acomodacaoK" ?
                Row(
                    children: <Widget>[
                      Text("Cat.: ", style: TextStyle( fontSize: 20.0, fontFamily: 'pp2')),
                      Text("ACOMODAÇÃO ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, fontFamily: 'pp2')),
                    ],
                ) : widget.servico ?
                Row(
                    children: <Widget>[
                      Text("Cat. ", style: TextStyle( fontSize: 20.0, fontFamily: 'pp2')),
                      Text("TRANSPORTES ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, fontFamily: 'pp2')),
                    ],
                ) : Text("Categoria Desconhecida!"),
              ), //container onde tem o switch case das categorias

              Container(
                margin: EdgeInsets.only(top: 10.0),
                child:  widget.servico == 'trans' ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    child: Text( 'Data de Partida: ' + widget.para, style: TextStyle(
                      fontFamily: "pp2",
                      fontSize: 16,
                      color: Colors.black,
                    ),),
                  ),
                ) : Text(""),
              ),

              Container(
                margin:EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 5.0),

                child: Column(
                  children: <Widget>[
                    Divider(thickness: .5, color: Colors.blue[300]),
                    Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 0.0, top: 0),
                        child: Text('AGENDAMENTOS ',
                            style: TextStyle(fontFamily: 'pp2', fontSize: 16.0,
                          fontWeight: FontWeight.bold, ))
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height * .3,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Container(
                        //Text('${agenda.toString()}'),
                        child: Container(
                          child: FutureBuilder(
                            future: GetAgendamentos(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.data != null) {
                                return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    List dados = snapshot.data;
                                    var servico = dados[index]['obs'];
                                    var telefone = dados[index]['telefone'];

                                    return  Container(
                                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.all(Radius.circular(9.0)),

                                      ),
                                      child: ListTile(
                                        leading: Container(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: Image(
                                              width:60,
                                              height: 700,
                                              fit: BoxFit.contain,
                                              image: CachedNetworkImageProvider(
                                                'https://kulolesaa.000webhostapp.com/${servico}/${dados[index]['foto']}',
                                              ),
                                            ),

                                          ),
                                        ),
                                        subtitle: Container(
                                          width: MediaQuery.of(context).size.width * .3,
                                          margin: EdgeInsets.symmetric(vertical: 5.0),
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  dados[index]['quem'].toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color: Colors.black,
                                                    fontFamily: "pp2",
                                                  ),
                                                ),
                                              ),

                                              Container(
                                                  margin: EdgeInsets.only(top: 2),
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "AOA",
                                                        style: TextStyle(
                                                          fontSize: 13.0,fontFamily: "pp2",
                                                        ),
                                                      ),
                                                      Text(" - ${dados[index]['preco']}", style: TextStyle(
                                                        fontFamily: "pp2",
                                                      )),
                                                    ],
                                                  )),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[

                                                  Container(
                                                      margin: EdgeInsets.only(top: 0),
                                                      alignment: Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Para",
                                                            style: TextStyle(
                                                              fontFamily: "pp2",
                                                            ),
                                                          ),
                                                          Text(
                                                              ": ${dados[index]['para']}", style: TextStyle(
                                                            fontFamily: "pp2",
                                                          )),
                                                        ],
                                                      )),

                                                  InkWell(
                                                    onTap: () async {
                                                      launch('tel://');
                                                      await FlutterPhoneDirectCaller.callNumber(telefone);

                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue[600],
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.local_phone_rounded, color: Colors.white, size: 15.0),
                                                          Container(
                                                            margin: EdgeInsets.only(left: 3.0),
                                                            child: Text(telefone, style: TextStyle(
                                                              fontFamily: "pp2",
                                                              color: Colors.white,
                                                            ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );

                                  },
                                );
                              } else {
                                return Container(
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 1.0, vertical: 20),
                                    child: Center(child: Text("Não fez ainda nenhuma reserva!")));
                              }
                            },
                          ),
                        ),
                      ),
                    ), // onde esta todos os agendamentos

                    Container(
                      alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Text('Avaliações ( ' + avc +' )', style: TextStyle(fontFamily: 'pp2', fontSize: 16.0, ))
                    ),
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
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator());
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
              )
            ],
          ),
        )
    );
  }
}




class Review extends StatefulWidget {
  var preco,para, servico, quando, id, quem, foto, espaco;
  Review(
      {this.quem,
        this.id,
        this.servico,
        this.espaco,
        this.preco,
        this.para,
        this.foto,
        this.quando,
      });

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  TextEditingController rev_text = new TextEditingController();

  bool loaing = false;

  double ? _ratingValue;

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
    });

    if(id == "") {

      if(id == "null"){
        Get.to(() => MyHomePage());
      }
    }
  }


  Future add_review() async {

    setState(() {
      loaing = true;
    });


    final link = Uri.parse("https://kulolesaa.000webhostapp.com/add_review.php");

    var digitadoo = {
      "comentario": rev_text.text,
      "id_serv": widget.id,
      "id_quem": id,
      "foto_quem": foto,
      "tipo_serv": widget.espaco,
      "quem": nome + " " + sobrenome,
      "aval": _ratingValue.toString(),
    };

    final pesquisarr = await http.post(link, body: digitadoo);
    final ress = jsonDecode(pesquisarr.body);
    print(ress);

    if(ress == "yes"){

      setState(() {
        loaing = false;
      });
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            alignment: Alignment.center,
            duration: Duration(milliseconds: 200),
            child: SucessoAG2()),
      );

    }

    return jsonDecode(pesquisarr.body);
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


  var dia, mes, ano, hora, min = "";

  @override
  void initState() {
    super.initState();
    GetDatas();
    CheckConection();

    var quan = widget.quando.split(" ");
    var dates = quan[0].split("-");
    var Hours = quan[1].split(":");

    setState(() {
      dia = dates[2];
      mes = dates[1];
      ano = dates[0];
      hora = Hours[0];
      min = Hours[1];
    });

  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Positioned(

                  child: Container(
                    padding: const EdgeInsets.only(top:30.0, left: 12.0, right: 12.0, bottom: 12.0),
                    color: Colors.transparent,
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
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Image.asset("assets/feedback.png", height: 90, width: 90),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    child: Text("Avaliar  " + widget.espaco, style: TextStyle(
                      fontFamily: "pp2",
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    child: Text("Efectuou este agendamento no dia ${dia} de ${mes} de ${ano}, as ${hora}h:${min}min", style: TextStyle(
                      fontFamily: "pp2",
                      fontSize: 15,
                      color: Colors.grey[700],
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),

                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    child: Text("Conte como foi sua experiencia neste serviço, como você avalia este serviço ?", style: TextStyle(
                      fontFamily: "pp2",
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    child:  TextField(
                      controller: rev_text,
                      decoration: const InputDecoration(
                          labelText: "Sua avaliação",
                          labelStyle: TextStyle(fontFamily: "pp2"),
                          prefixIcon: Icon(
                            Icons.edit_outlined,
                            size: 15.0,
                          ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        size: 15.0,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {

                          _ratingValue = rating;
                          print(rating);
                        });
                      },
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40.0),
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                        ),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blue[700]),
                      ),
                      onPressed: () {
                        add_review();
                      },
                      child: loaing == false
                          ? Row(
                            children: [

                              Spacer(),
                               Text(
                        'Enviar',
                        style: TextStyle(
                              color: Colors.white,
                              fontFamily: "pp2",
                              fontSize: 18.0,
                        ),
                      ),
                              Spacer(),
                              Container(
                                child: Icon(Icons.send_outlined, size: 15)
                              )
                            ],
                          )
                          : SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        )
    );
  }
}



//Pagina dos favoritos

class Favoritos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Icon(Icons.arrow_back_ios),
          ),
          Container(
              margin: EdgeInsets.only(left: 10, top: 50),
              child: const Text(
                'FAVORITOS',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "pp2",
                ),
              )),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: const Text(
              'Crie a sua primeira lista de favoritos',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: "pp2",
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 15, left: 10, top: 10),
              child: Row(
                children: [
                  Container(
                    height: 90.0,
                    width: 90.0,
                    child: Image.asset(
                      "assets/Ku.png",
                      height: 90.0,
                      width: 90.0,
                    ),
                  ),
                  Text(
                    'À medida que pesquisa, toque no ícone de coração para gravar os seus alojamentos ou coisas para fazer numa lista de favoritos',
                    style: TextStyle(
                      fontSize: 15.0, fontFamily: "pp2",
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class DadosPerfil extends StatefulWidget {
  @override
  _DadosPerfilState createState() => _DadosPerfilState();
}

class _DadosPerfilState extends State<DadosPerfil> {
  

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
      nascimento = dados.getString("quando").toString()!;
      foto = dados.getString("foto").toString()!;
      estado = dados.getString("estado").toString();
    });

    if(id == "null"){
      Get.to(() => MyHomePage());
    }
  }
  var p = "";

void getPhotos() async {
  final uri = Uri.parse("https://kulolesaa.000webhostapp.com/get_p.php?id=" + id);

  final resposta = await http.get(uri);
  var dados = jsonDecode(resposta.body);

  setState(() {
    p = "https://kulolesaa.000webhostapp.com/perfil/" + dados['foto'];
  });
  print(dados);
}

  @override
  void initState() {
    super.initState();
    todosDados();
     getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // PARTE ONDE CONTEM AS CENAS DO PERFIL E DESCRICAO
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .35),
            padding: EdgeInsets.only(top: 10.0),
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    padding: EdgeInsets.only(left: 15.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Configurações da conta',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "pp2",
                        fontSize: 25.0,
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 8.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/person.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      InfoPessoal()),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Informações Pessoais',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "pp2",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 15.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/pay.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Pagamento()
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Pagamentos e Recebimentos',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "pp2",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 15.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/bell.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 300),
                                child: Perfil(),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Notificações',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "pp2",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // parte das hospedagens

                  InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>InfoPessoal()),);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 25.0),
                      padding: EdgeInsets.only(left: 15.0),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Seus Serviços',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          fontFamily: "pp2",
                        ),
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 8.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/house.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            estado != "Usuario"
                                ? Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 250),
                                      child: Anounce(),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 300),
                                      child: AlterarConta(),
                                    ),
                                  );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Anuncie o seu espaço',
                              style: TextStyle(
                                fontFamily: "pp2",
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 15.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/information (1).png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            estado != "Usuario"
                                ? Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 300),
                                      child: Outros(),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 300),
                                      child: AlterarConta(),
                                    ),
                                  );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Outros serviços',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "pp2",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //AREA OU PARTE DOS APOIOS

                  Container(
                    margin: EdgeInsets.only(top: 25.0),
                    padding: EdgeInsets.only(left: 15.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Apoio',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        fontFamily: "pp2",
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 8.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/logo.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 300),
                                child: ComoFunciona(),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Como funciona o App',
                              style: TextStyle(
                                fontFamily: "pp2",
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 15.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/shield.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 300),
                                child: Seguranca(),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Centro de segurança',
                              style: TextStyle(
                                fontFamily: "pp2",
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 15.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/information (2).png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 300),
                                child: Ajuda(),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Obter ajuda',
                              style: TextStyle(
                                fontFamily: "pp2",
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 15.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/feedback.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      FeedBack()),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Dê nos feedback',
                              style: TextStyle(
                                fontFamily: "pp2",
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // parte LEGAL AREA

                  Container(
                    margin: EdgeInsets.only(top: 25.0),
                    padding: EdgeInsets.only(left: 15.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Legal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        fontFamily: "pp2",
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 8.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/terms-and-conditions.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Termos()),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Termos e serviços',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "pp2",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 15.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/padlock (1).png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Privacidade()),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: const Text(
                              'Políticas de privacidade',
                              style: TextStyle(
                                fontFamily: "pp2",
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SAIR E VERSÃO

                  InkWell(
                    onTap: () async {
                      final SharedPreferences sair = await SharedPreferences.getInstance();

                      await sair.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                              (route) => false);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      padding: EdgeInsets.only(left: 15.0),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'SAIR',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "pp2",
                            fontSize: 20.0,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 15.0,
                    ),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/logo.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: const Text(
                            'Versão do App 1.0.0',
                            style: TextStyle(
                              fontSize: 16.0,
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

          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .37,
                padding: EdgeInsets.only(top: 5.0, left: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 3.0, top: 30.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 60.0,
                        margin: EdgeInsets.only(bottom: 10.0),
                        width: 60.0,
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
  imageUrl: 'https://kulolesaa.000webhostapp.com/perfil/$foto',
  placeholder: (context, url) => CircularProgressIndicator(), // Indicador de carregamento enquanto a imagem é buscada na internet
  errorWidget: (context, url, error) => Icon(Icons.error), // Widget a ser exibido em caso de erro ao carregar a imagem
),



                          //Image.network( fit: BoxFit.cover,),

                          /*  Image.network("https://kulolesaa.000webhostapp.com/perfil/img1.png",
                                         fit: BoxFit.cover,),*/
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AddF()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 0.0, bottom: 5.0, left: 14.0),
                          child:  Text(
                            "Editar Foto",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                              fontFamily: "pp2",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3.0),
                        child: Text(
                          "$nome $sobrenome",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "Conta: $estado",
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Colors.white,
                          fontFamily: "pp2",
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0, top: 3.0),
                        child: const Text(
                          'Ganhe dinheiro com o seu espaço extra',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontFamily: "pp2",
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.topToBottom,
                              duration: Duration(milliseconds: 100),
                              child: ComoFunciona(),
                            ),
                          );
                        },
                        child: const Text(
                          'Saiba mais',
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.white,
                              fontFamily: "pp2",
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//função para as acomoddações

class Acomodacoes extends StatefulWidget {
  @override
  _AcomodacoesState createState() => _AcomodacoesState();
}

class _AcomodacoesState extends State<Acomodacoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        child: const Center(
          child: Text(
              'é suposto nesta página vir os dados ou estilo para as acomodações'),
        ),
      ),
    );
  }
}

// PAGINA DAS INFORMACOES PESSOAIS

class InfoPessoal extends StatefulWidget {
  @override
  _InfoPessoalState createState() => _InfoPessoalState();
}

class _InfoPessoalState extends State<InfoPessoal> {
  bool processandoPedido = false;
  String nome = "";
  String id = "";
  String quando = "";
  String sobrenome = "";
  String email = "";
  String telefone = "";
  String estado = "";
  TextEditingController nome_ctr = new TextEditingController();
  TextEditingController sobrenome_ctr = new TextEditingController();
  TextEditingController telefone_ctr = new TextEditingController();
  TextEditingController email_ctr = new TextEditingController();
  TextEditingController estado_ctr = new TextEditingController();
  TextEditingController quando_ctr = new TextEditingController();

  Future todosDados() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var qqq = pref.getString("quando")!.split(" ");
    setState(() {
      nome = pref.getString("nome").toString();
      id = pref.getString("id").toString();
      estado = pref.getString("estado").toString();
      sobrenome = pref.getString("sobrenome").toString();
      email = pref.getString("email").toString();
      telefone = pref.getString("telefone").toString();
      quando = pref.getString("quando").toString();

      nome_ctr.text = nome;
      email_ctr.text = email;
      telefone_ctr.text = telefone;
      sobrenome_ctr.text = sobrenome;
      estado_ctr.text = estado;

      quando_ctr.text = qqq[0];
    });


    if(id == "null"){
      Get.to(() => MyHomePage());
    }
  }

  @override
  void initState() {
    super.initState();
    todosDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(bottom: 15.0, top: 30.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      bottom: 25.0, left: 20.0, right: 20.0),
                  child: const Text(
                    'Editar suas informações pessoais',
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
                    controller: TextEditingController(text: id),
                    enabled: false,
                    decoration:
                        const InputDecoration(labelText: 'ID de usuário', labelStyle: TextStyle(
                          fontFamily: "pp2",)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: nome_ctr,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                    ],
                    decoration:
                        const InputDecoration(labelText: 'Primeiro Nome', labelStyle: TextStyle(
                          fontFamily: "pp2",)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: sobrenome_ctr,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                    ],
                    decoration: const InputDecoration(labelText: 'Último Nome', labelStyle: TextStyle(
                      fontFamily: "pp2",)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: email_ctr,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email',  labelStyle: TextStyle(
                      fontFamily: "pp2",)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: telefone_ctr,
                    keyboardType: TextInputType.number,
                    maxLength: 13,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    decoration: const InputDecoration(labelText: 'Telefone',  labelStyle: TextStyle(
                      fontFamily: "pp2",)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    controller: estado_ctr,
                    enabled: false,
                    decoration: InputDecoration(labelText: 'Conta',  labelStyle: TextStyle(
                      fontFamily: "pp2",)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 25.0),
                  child: TextFormField(
                    controller: quando_ctr,
                    enabled: false,
                    decoration:
                        const InputDecoration(labelText: 'Data de Cadastro',  labelStyle: TextStyle(
                          fontFamily: "pp2",)),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.shade700),
                  ),
                  onPressed: () {
                    setState(() {
                      processandoPedido = true;
                    });

                    Future.delayed(const Duration(milliseconds: 3500), () {
                      setState(() {
                        processandoPedido = false;
                      });

                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 300),
                          child: SucessoAG(),
                        ),
                      );
                    });
                  },
                  child: processandoPedido == false
                      ? Text(
                          'Solicitar Alteração',
                          style: TextStyle(color: Colors.white,
                            fontFamily: 'pp2',),
                        )
                      : SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            color: Colors.lightBlueAccent,
                            backgroundColor: Colors.white,
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

// notificacoes pagina

class Pagamento extends StatefulWidget {
  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(bottom: 15.0, top: 30.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
              child: const Text(
                'Os seus pagamentos e recebimentos',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "pp2",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: const Text(
                  ' Tendo feito uma reserva aqui poderá visualizar os seus pagamentos', style: TextStyle(
                fontFamily: "pp2",
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class Privacidade extends StatefulWidget {
  @override
  _PrivacidadeState createState() => _PrivacidadeState();
}

class _PrivacidadeState extends State<Privacidade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.blue[700]),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Políticas de Privacidade",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
            fontSize: 24.0,
            fontFamily: 'pp2',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(bottom: 15.0, top: 30.0),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 30.0),
                child: Text(
                  'A sua privacidade',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontFamily: "pp2",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                            ' A sua privacidade é importante para nós. É política do Kulolesa respeitar a sua privacidade em relação a qualquer informação sua que possamos coletar no site Kulolesa, e outros sites que possuímos e operamos. \n\n Solicitamos informações pessoais apenas quando realmente precisamos delas para lhe fornecer um serviço. Fazemo-lo por meios justos e legais, com o seu conhecimento e consentimento. Também informamos por que estamos coletando e como será usado.\n\n Apenas retemos as informações coletadas pelo tempo necessário para fornecer o serviço solicitado. Quando armazenamos dados, protegemos dentro de meios comercialmente aceitáveis ​​para evitar perdas e roubos, bem como acesso, divulgação, cópia, uso ou modificação não autorizados.'
                            '\n Não compartilhamos informações de identificação pessoal publicamente ou com terceiros, exceto quando exigido por lei.'
                            '\n O nosso site pode ter links para sites externos que não são operados por nós. Esteja ciente de que não temos controle sobre o conteúdo e práticas desses sites e não podemos aceitar responsabilidade por suas respectivas políticas de privacidade.'
                            '\n Você é livre para recusar a nossa solicitação de informações pessoais, entendendo que talvez não possamos fornecer alguns dos serviços desejados.'
                            '\n O uso continuado de nosso site será considerado como aceitação de nossas práticas em torno de Aviso de Privacidad e informações pessoais. Se você tiver alguma dúvida sobre como lidamos com dados do usuário e informações pessoais, entre em contacto connosco.', style: TextStyle(fontFamily: 'pp2')),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25, bottom: 12),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Compromisso do usuario",
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black,
                            fontFamily: "pp2",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                            "O usuário se compromete a fazer uso adequado dos conteúdos e da informação que a Kulolesa oferece no site e com caráter enunciativo, mas não limitativo:"
                            '\nA) Não se envolver em atividades que sejam ilegais ou contrárias à boa fé a à ordem pública;'
                            '\n\nB) Não difundir propaganda ou conteúdo de natureza racista, xenofóbica, apostas online ou azar, qualquer tipo de pornografia ilegal, de apologia ao terrorismo ou contra os direitos humanos;'
                            '\n\nC) Não causar danos aos sistemas físicos (hardwares) e lógicos (softwares) do Kulolesa, de seus fornecedores ou terceiros, para introduzir ou disseminar vírus informáticos ou quaisquer outros sistemas de hardware ou software que sejam capazes de causar danos anteriormente mencionados.', style: TextStyle(fontFamily: 'pp2')),
                      ),
                    ],
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

class Termos extends StatefulWidget {
  @override
  _TermosState createState() => _TermosState();
}

class _TermosState extends State<Termos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(Icons.arrow_back, color: Colors.blue[700]),
          ),
        ),
        leadingWidth: 35,
        title: Text(
          'Termos de Serviços',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
            fontFamily: 'pp2'
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 18.0),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Kulolesa App",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                    ' Ao navegar neste website, você está automaticamente de acordo com nossa política. Do contrário, orientamos a que suspenda a navegação no website e evite concluir o seu cadastro.'
                    '\n\nA política  poderá ser editada a qualquer momento, mas, caso isso aconteça, publicaremos no website, com a data de revisão atualizada. Por outro lado, se as alterações forem substanciais, nós teremos o cuidado, além de divulgar no website, de informá-lo por meio das informações de contato que tivermos em nosso cadastro, ou por meio de notificações.'
                    '\n\nA utilização deste website após as alterações significa que você aceitou a política revisada. Caso, após a leitura da nova versão, você não esteja de acordo com seus termos, favor encerrar o seu acesso.'),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Capitulo 1 - Usuário",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: const Text(
                      'A utilização deste website atribui de forma automática a condição de usuário e implica a plena aceitação de todas as diretrizes e condições incluídas nestes Termos.'),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Capítulo 2 - Adesão em conjunto com a Política de Privacidade",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                      'A utilização deste website acarreta a adesão à presente Política de Uso e à versão mais atualizada da Política de Privacidade de Kulolesa.'),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Capítulo 3 - Condições de acesso",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: const Text(
                      'Para usufruir de algumas funcionalidades, o usuário poderá precisar efetuar um cadastro, criando uma conta de usuário com login e senha próprios para acesso.'
                      '\n\n Toda e qualquer publicação de serviço deverá ser revisado primerio antes de ser apresentado para potenciais usuários e só depois da revisão será aprovado ou negado de estar no aplicativo'
                      '\n\n É de total responsabilidade do usuário fornecer apenas informações corretas, autênticas, válidas, completas e atualizadas, bem como não divulgar o seu login e senha para terceiros.'
                      '\n\n Partes deste aplicativo oferecem ao usuário a opção de publicar feedbacks e serviços em campos dedicados. Kulolesa não consente com publicações discriminatórias, ofensivas ou ilícitas, ou ainda infrinjam direitos de autor ou quaisquer outros direitos de terceiros.'
                      '\n\n A publicação de quaisquer conteúdos pelo usuário deste aplicativo, incluindo, mas não se limitando, a  serviços e feedbacks, implica licença não-exclusiva, irrevogável e irretratável, para sua utilização, reprodução e publicação pela Kulolesa em seu aplicativo, plataformas e aplicações de internet, ou ainda em outras plataformas, sem qualquer restrição ou limitação.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class MyServices extends StatefulWidget {
  @override
  _MyServicesState createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {


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
    });

    String val = pref.getString("id").toString();
    if (val == "") {

      if(id == "null"){
        Get.to(() => LoginPage());
      }
    }
  }




  Future GetAgendamentosAcom() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/myservs.php");


    var digitado = {
      "servico": id,
      "tipo": 'acom',
    };

    final pesquisar = await http.post(link, body: digitado);
    final res = jsonDecode(pesquisar.body);
    print(res);
    return jsonDecode(pesquisar.body);
  }

  Future GetAgendamentosTrasp() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/myservs.php");


    var digitado = {
      "servico": id,
      "tipo": 'transportes',
    };

    final pesquisar = await http.post(link, body: digitado);
    final res = jsonDecode(pesquisar.body);
    print(res);
    return jsonDecode(pesquisar.body);
  }

  Future GetAgendamentosExpe() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/myservs.php");


    var digitado = {
      "servico": id,
      "tipo": 'exp_kulolesa',
    };

    final pesquisar = await http.post(link, body: digitado);
    final res = jsonDecode(pesquisar.body);
    print(res);
    return jsonDecode(pesquisar.body);
  }


  bool load = false;

  Future DeleteServ(idServ, tipoServ) async {

    setState(() {
      load = true;
    });

    final link = Uri.parse("https://kulolesaa.000webhostapp.com/delete_serv.php");


    var digitado = {
      "meu_id": id,
      "id_serv": idServ.toString(),
      "tipoServ": tipoServ.toString(),
    };

    final pesquisar = await http.post(link, body: digitado);
    final res = jsonDecode(pesquisar.body);
    print(res);
    print(idServ +" "+ tipoServ);


    if(res == "sim"){
      timerSnackbar(
        context: context,
        backgroundColor: Colors.green[300],
        contentText:
        "Seu serviço foi eliminado com sucesso!",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("eliminado com sucesso ."),
        second: 8,
      );

      setState(() {
        load = false;
      });

    }
    else {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.red[300],
        contentText:
        "Ocorreu um erro ao eliminar serviço!",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("eliminado com sucesso ."),
        second: 8,
      );

      setState(() {
        load = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    GetAgendamentosAcom();
    GetAgendamentosTrasp();
    GetAgendamentosExpe();
    GetDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation:0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(Icons.arrow_back, color: Colors.blue[700]),
          ),
        ),
        leadingWidth: 35,
        title: Text(
          'Seus Serviços',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
            fontFamily:'pp2',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 1.0, right: 1.0, top: 0),
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only( top: 10),
                  child: load == false ? Text("") : SizedBox(
                    height: 25.0,
                    width: 25.0,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Seus serviços no aplicativo",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  height: MediaQuery.of(context).size.height * .30,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Container(
                    //Text('${agenda.toString()}'),
                    child: Container(
                      child: FutureBuilder(
                        future: GetAgendamentosAcom(),
                        builder: (context, AsyncSnapshot snapshot) {
                          // snapshot.data. == 0 ? Text("Sem Servico") : Text("");
                          if (snapshot.data != null) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                List dados = snapshot.data;
                                var id = dados[index]['id'];
                                var user = dados[index]['usuario'];
                                var desc = dados[index]['descricao'];
                                var para = dados[index]['para'];
                                var local = dados[index]['localizacao'];
                                var disp = dados[index]['disponivel'];
                                var quando = dados[index]['quando'];
                                var foto = dados[index]['foto'];
                                var preco = dados[index]['preco'];
                                var espaco = dados[index]['espaco'];

                                return  Container(
                                  margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.all(Radius.circular(9.0)),

                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image(
                                          width:60,
                                          height: 700,
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            'https://kulolesaa.000webhostapp.com/acomodacaoK/${dados[index]['foto']}',
                                          ),
                                        ),

                                      ),
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5.0),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              dados[index]['espaco'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                                color: Colors.black,
                                                fontFamily: "pp2",
                                              ),
                                            ),
                                          ),

                                          Container(
                                              margin: EdgeInsets.only(top: 2),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "AOA",
                                                    style: TextStyle(
                                                      fontSize: 13.0,fontFamily: "pp2",
                                                    ),
                                                  ),
                                                  Text(" - ${dados[index]['preco']}", style: TextStyle(
                                                    fontFamily: "pp2",
                                                  )),
                                                ],
                                              ),),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              DeleteServ(id, 'acomodacaoK');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius: BorderRadius.circular(80),
                                              ),
                                              child: Icon(Icons.delete_outline_outlined, color:Colors.blue[700], size: 30.0),
                                            ),
                                          ),
                                          Spacer(),

                                          InkWell(
                                            onTap: () {

                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.rightToLeft,
                                                  duration: Duration(milliseconds: 100),
                                                  child: VerAdmin(servico: 'acomodacaoK', id: id, disp: disp, espaco: espaco, preco: preco, foto: foto, quando: quando, para: para, user: user, local: local, desc:desc),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[600],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text("Ver", style: TextStyle(
                                                fontFamily: "pp2",
                                                color: Colors.white,

                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              },
                            );
                          } else {
                            return Container(
                                height: MediaQuery.of(context).size.height * 1,
                                margin:
                                EdgeInsets.symmetric(horizontal: 1.0, vertical: 20),
                                child: Center(child: Text(" ")));
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .35,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Container(
                    //Text('${agenda.toString()}'),
                    child: Container(
                      child: FutureBuilder(
                        future: GetAgendamentosTrasp(),
                        builder: (context, AsyncSnapshot snapshot) {
                          // snapshot.data. == 0 ? Text("Sem Servico") : Text("");
                          if (snapshot.data != null) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                List dados = snapshot.data;
                                var id = dados[index]['id'];
                                var user = dados[index]['usuario'];
                                var desc = dados[index]['descricao'];
                                var para = dados[index]['quando_sai'];
                                var local = dados[index]['para'];
                                var disp = dados[index]['disponivel'];
                                var quando = dados[index]['quando'];
                                var foto = dados[index]['foto_carro'];
                                var preco = dados[index]['preco'];
                                var espaco = dados[index]['marca'];

                                return  Container(
                                  margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.all(Radius.circular(9.0)),

                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image(
                                          width:60,
                                          height: 700,
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            'https://kulolesaa.000webhostapp.com/trans/${dados[index]['foto_carro']}',
                                          ),
                                        ),

                                      ),
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5.0),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              dados[index]['marca'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                                color: Colors.black,
                                                fontFamily: "pp2",
                                              ),
                                            ),
                                          ),

                                          Container(
                                              margin: EdgeInsets.only(top: 2),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "AOA",
                                                    style: TextStyle(
                                                      fontSize: 13.0,fontFamily: "pp2",
                                                    ),
                                                  ),
                                                  Text(" - ${dados[index]['preco']}", style: TextStyle(
                                                    fontFamily: "pp2",
                                                  )),
                                                ],
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(top: 0),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Para",
                                                    style: TextStyle(
                                                      fontFamily: "pp2",
                                                    ),
                                                  ),
                                                  Text(
                                                      ": ${dados[index]['para']}", style: TextStyle(
                                                    fontFamily: "pp2",
                                                  )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              DeleteServ(id, 'trans');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius: BorderRadius.circular(80),
                                              ),
                                              child: Icon(Icons.delete_outline_outlined, color:Colors.blue[700], size: 30.0),
                                            ),
                                          ),
                                          Spacer(),

                                          InkWell(
                                            onTap: () {

                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.rightToLeft,
                                                  duration: Duration(milliseconds: 100),
                                                  child: VerAdmin(servico: 'trans', id: id, disp: disp, espaco: espaco, preco: preco, foto: foto, quando: quando, para: para, user: user, local: local, desc:desc),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[600],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text("Ver", style: TextStyle(
                                                fontFamily: "pp2",
                                                color: Colors.white,

                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              },
                            );
                          } else {
                            return Container(
                                height: MediaQuery.of(context).size.height * 1,
                                margin:
                                EdgeInsets.symmetric(horizontal: 1.0, vertical: 20),
                                child: Center(child: Text("Não fez ainda nenhuma reserva!")));
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .35,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Container(
                    //Text('${agenda.toString()}'),
                    child: Container(
                      child: FutureBuilder(
                        future: GetAgendamentosExpe(),
                        builder: (context, AsyncSnapshot snapshot) {
                          // snapshot.data. == 0 ? Text("Sem Servico") : Text("");
                          if (snapshot.data != null) {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                List dados = snapshot.data;
                                var id = dados[index]['id'];
                                var user = dados[index]['usuario'];
                                var desc = dados[index]['descricao'];
                                var para = dados[index]['localizacao'];
                                var local = dados[index]['telefone'];
                                var disp = dados[index]['disponivel'];
                                var quando = dados[index]['quando'];
                                var foto = dados[index]['foto'];
                                var preco = dados[index]['preco'];
                                var espaco = dados[index]['tipo_exp'];

                                return  Container(
                                  margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.all(Radius.circular(9.0)),

                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image(
                                          width:60,
                                          height: 700,
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            'https://kulolesaa.000webhostapp.com/expe/${dados[index]['foto']}',
                                          ),
                                        ),

                                      ),
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5.0),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              dados[index]['tipo_exp'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                                color: Colors.black,
                                                fontFamily: "pp2",
                                              ),
                                            ),
                                          ),

                                          Container(
                                              margin: EdgeInsets.only(top: 2),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "AOA",
                                                    style: TextStyle(
                                                      fontSize: 13.0,fontFamily: "pp2",
                                                    ),
                                                  ),
                                                  Text(" - ${dados[index]['preco']}", style: TextStyle(
                                                    fontFamily: "pp2",
                                                  )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              DeleteServ(id, 'expe');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius: BorderRadius.circular(80),
                                              ),
                                              child: Icon(Icons.delete_outline_outlined, color:Colors.blue[700], size: 30.0),
                                            ),
                                          ),
                                          Spacer(),

                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.rightToLeft,
                                                  duration: Duration(milliseconds: 100),
                                                  child: VerAdmin(servico: 'expe', id: id, disp: disp, espaco: espaco, preco: preco, foto: foto, quando: quando, para: para, user: user, local: local, desc:desc),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[600],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text("Ver", style: TextStyle(
                                                fontFamily: "pp2",
                                                color: Colors.white,

                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              },
                            );
                          } else {
                            return Container(
                                height: MediaQuery.of(context).size.height * 1,
                                margin:
                                EdgeInsets.symmetric(horizontal: 1.0, vertical: 20),
                                child: Center(child: Text("Não fez ainda nenhuma reserva!")));
                          }
                        },
                      ),
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
}




class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.blue[700]),
        ),
        title: Text("AVALIE NOS",
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 28.0,
              fontWeight: FontWeight.bold
            )),
        shadowColor: Colors.transparent,
        leadingWidth: 35.0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(bottom: 15.0, top: 30.0),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 22.0),
              child: Text(
                'Partilhe o seu FeedBack',
                style: TextStyle(
                  fontSize: 22.0,
                  fontFamily: "pp2",
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
              child: const Text(
                  ' Ajuda-nos a melhorar, partilhando as suas ideias, problemas ao usar o aplicativo ou agradecimentos. Não podemos responder individualmente, mas iremos transmitir para as equipas que trabalham para tornar o aplicativo melhor para todos'),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 0.0, bottom: 1.0),
                child: SizedBox(
                    height: 40.0,
                    width: 300,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Escreva o seu FeedBack ',
                      ),
                    )),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                )),
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue.shade700),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage1()));
              },
              child: const Text(
                'ENVIAR',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Seguranca extends StatefulWidget {
  @override
  _SegurancaState createState() => _SegurancaState();
}

class _SegurancaState extends State<Seguranca> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Icon(Icons.arrow_back, color: Colors.blue[700]),
          ),
        ),
        leadingWidth: 35.0,
        title: Text(
          'Centro de Segurança',
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: 'pp2',
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                child: Image.asset(
                  'assets/shield.png',
                  height: 100.0,
                  width: 100.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 14.0, right: 14.0),
              child: const Text(
                  'Obtenha apoio, ferramentas e informações necessárias para estar seguro no aplicativo \n\n Aceda www.kulolesa.com ',
                  style: TextStyle(fontSize: 18.0, fontFamily: 'pp2')),
            ),
          ],
        ),
      ),
    );
  }
}

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

  String idd = "";
  String conta = "";
  String nome = "";

  Future EnviarDados() async {
    setState(() {
      loaing = true;
    });

    final uri = Uri.parse("https://kulolesaa.000webhostapp.com/add_spaces.php");

    var request = http.MultipartRequest('POST', uri);
    request.fields["espaco"] = espaco.text;
    request.fields["descricao"] = descricao.text;
    request.fields["localizacao"] = local.text;
    request.fields["disp"] = ate.text;
    request.fields["preco"] = preco.text;
    request.fields["conta"] = idd;
    request.fields["pro"] = "Luanda";
    var pic = await http.MultipartFile.fromPath("image", imagem!.path);
    request.files.add(pic);
    var resposta = await request.send();

    if (resposta.statusCode != 402) {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.green[300],
        contentText:
            "Seu anúncio está sendo revisado, será notificado em breve!",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("anuncio adicionado com sucesso ."),
        second: 8,
      );

      setState(() {
        loaing = false;
      });

      Navigator.pop(context);
    } else if (resposta == "erro") {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.red[300],
        contentText: "Ocorreu um erro ao tentar anunciar o seu serviço!",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () =>
            print("Ocorreu um erro ao tentar executar esta acçao ..."),
        second: 8,
      );

      setState(() {
        loaing = false;
      });
    } else if (resposta == "vazio") {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.orange[100],
        contentText: "Por favor preencha os campos vazios",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("o anuncio contem campos vazios "),
        second: 8,
      );
    }
  }

  File? imagem;

  final formKey = new GlobalKey<FormState>();

  void GetDatass() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome == pref.getString("token");
      idd == pref.getString("id");
      conta == pref.getString("tipo");
    });
  }

  @override
  void initState() {
    super.initState();
    GetDatass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(Icons.arrow_back, color: Colors.blue[700])),
        ),
        leadingWidth: 30.0,
        shadowColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          "Anunciar seu espaço $idd",
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 28.0,
            fontFamily: "pp2",
          ),
        ),
        backgroundColor: Colors.white,
      ),
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
                                        width: MediaQuery.of(context).size.width * .4,
                                        decoration: BoxDecoration(
                                color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(15.0),

                              ),
                                        child: InkWell(
                                          onTap: () => getImagemm(),
                                          child: Icon(
                                            Icons
                                                .enhance_photo_translate_outlined,
                                            color: Colors.blue[700], size: 40
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0)),
                                      Container(
                                        height: 150,
                                        width: MediaQuery.of(context).size.width * .4,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(15.0),

                                        ),
                                        child: InkWell(
                                          onTap: () => getImagem(),
                                          child: Icon(
                                            Icons.photo_outlined,
                                            color: Colors.blue[700], size: 40
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0)),
                                  Text("Foto do espaço", style: TextStyle(
                                    fontFamily: "pp2",
                                  )),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: espaco,
                    decoration: const InputDecoration(
                      labelText: "Nome do espaço",
                      labelStyle: TextStyle(
                        fontFamily: "pp2",
                      ),
                      prefixIcon: Icon(Icons.hotel_outlined, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: descricao,
                    decoration: const InputDecoration(
                      labelText: "Breve descrição do espaço ",
                      labelStyle: TextStyle(
                        fontFamily: "pp2",
                      ),
                      prefixIcon: Icon(Icons.edit_note_rounded, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: local,
                    decoration: const InputDecoration(
                      labelText: "Localização",
                      labelStyle: TextStyle(
                        fontFamily: "pp2",
                      ),
                      prefixIcon: Icon(Icons.location_on_outlined, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: ate,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: "pp2",
                      ),
                      labelText: "Disponível até:",
                      prefixIcon: Icon(Icons.calendar_month)
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: preco,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Preço ",
                        labelStyle: TextStyle(
                          fontFamily: "pp2",
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
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(44.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue.shade700),
                      ),
                      onPressed: () {
                        EnviarDados();
                      },
                      child: loaing == false
                          ? const Text(
                              'Anunciar',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "pp2",
                                fontSize: 15.0,
                              ),
                            )
                          : SizedBox(
                              height: 25.0,
                              width: 25.0,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Colors.lightBlueAccent,
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
    );
  }

  getImagem() async {
    final imgTempp = await ImagePicker().getImage(source: ImageSource.gallery);

    if (imgTempp != null) {
      setState(() {
        imagem = File(imgTempp.path);
      });
    }
  }

  getImagemm() async {
    final imgTempp = await ImagePicker().getImage(source: ImageSource.camera);

    if (imgTempp != null) {
      setState(() {
        imagem = File(imgTempp.path);
      });
    }
  }
}

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
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        title: const Text(
          "Escolha um dos serviços",
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: "pp2",
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        margin: EdgeInsets.only(top: 20.0),
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
                    duration: Duration(milliseconds: 200),
                    child: AddPost(),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .5,
                padding: EdgeInsets.all(2),
                child: Card(
                  shadowColor: Colors.grey[300],
                  color: Colors.blue[50],
                  margin: EdgeInsets.all(15),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          child:  Icon(Icons.explore_outlined,
                              size: 55, color: Colors.blue[700]),
                        ),
                        Center(
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              child:  Text(
                                "Actividades",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 20.0,
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
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 200),
                    child: Transpp(),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .5,
                child: Card(
                  shadowColor: Colors.grey[300],
                  color: Colors.blue[50],
                  margin: EdgeInsets.all(15),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Icon(Icons.directions_bus_outlined,
                              size: 55, color: Colors.blue[700]),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child:  Text(
                              "Transportes",
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 20.0,
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
            ),
          ],
        ),
      ),
    );
  }
}

class Act extends StatefulWidget {
  const Act({Key? key}) : super(key: key);

  @override
  State<Act> createState() => _ActState();
}

class _ActState extends State<Act> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class Transpp extends StatefulWidget {
  @override
  State<Transpp> createState() => _TransppState();
}

class _TransppState extends State<Transpp> {
  TextEditingController marca = new TextEditingController();
  TextEditingController descricao = new TextEditingController();
  TextEditingController preco = new TextEditingController();
  TextEditingController onde = new TextEditingController();
  TextEditingController lugares = new TextEditingController();
  TextEditingController trajecto = new TextEditingController();
  bool loaing = false;

  String id = "";
  String conta = "";
  String nome = "";
  String telefone = "";

  Future EnviarDados() async {
    setState(() {
      loaing = true;
    });
    final uri = Uri.parse("https://kulolesaa.000webhostapp.com/add_trans.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields["descricao"] = descricao.text;
    request.fields["trajecto"] = trajecto.text;
    request.fields["marca"] = marca.text;
    request.fields["onde"] = onde.text;
    request.fields["conta"] = id;
    request.fields["preco"] = preco.text;
    request.fields["tel"] = telefone;
    request.fields["lugares"] = lugares.text;
    request.fields["prov"] = "LUANDA";

    var pic = await http.MultipartFile.fromPath("image", imagem!.path);
    request.files.add(pic);

    var resposta = await request.send();

    if (resposta.statusCode != 402) {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.green[300],
        contentText:
            "Anunciado com sucesso, seu anúncio está em revisão será notificado em breve!",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () =>
            print("Ocorreu um erro ao tentar executar esta acçao ..."),
        second: 10,
      );

      Navigator.pop(context);

      setState(() {
        loaing = false;
      });
    } else if (resposta == "erro") {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.red[300],
        contentText: "Ocorreu um erro ao tentar anunciar o seu serviço!",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () =>
            print("Ocorreu um erro ao tentar executar esta acçao ..."),
        second: 8,
      );

      setState(() {
        loaing = false;
      });
    } else if (resposta == "vazio") {
      CoolAlert.show(
        context: context,
        title: "Campos vazios",
        backgroundColor: Colors.red.shade100,
        autoCloseDuration: Duration(seconds: 6),
        type: CoolAlertType.error,
        confirmBtnColor: Colors.blue.shade700,
        text: "Por favor preencha os camopos vazios",
      );
    }

    setState(() {
      loaing = false;
    });
  }

  File? imagem;
  late String _myActivity;
  final formKey = new GlobalKey<FormState>();

  void GetDatass() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("nome").toString();
      id = pref.getString("id").toString();
      conta = pref.getString("tipo").toString();
      telefone = pref.getString("telefone").toString();
    });


    String val = pref.getString("id").toString();
    if (val == "") {

      if(id == "null"){
        Get.to(() => LoginPage());
      }
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
    _myActivity = '';
      CheckConection();
    GetDatass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Anuncie seu transporte",
          style: TextStyle(
            color: Colors.blue[700],
            fontFamily: "pp2",
            fontSize: 20.0,
          ),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Icon(Icons.arrow_back, color: Colors.blue[700]),
            )),
        backgroundColor: Colors.white,
      ),
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
                              margin: EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: MediaQuery.of(context).size.width * .4,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(15.0),

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
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0)),
                                      Container(
                                        height: 150,
                                        width: MediaQuery.of(context).size.width * .4,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(15.0),

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
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0)),
                                  Text("Foto da Viatura", style: TextStyle(
                                    fontFamily: "pp2",)),
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
                      labelStyle: TextStyle(fontFamily: "pp2",),
                      prefixIcon: Icon(Icons.directions_bus_filled_outlined,
                          size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: lugares,
                    decoration: const InputDecoration(
                      labelText: "Lugares  ",
                      labelStyle: TextStyle(fontFamily: "pp2",),
                      prefixIcon: Icon(Icons.people_alt_outlined, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: descricao,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: "Data de partida (dd/mm/aaaa hh)",
                      labelStyle: TextStyle(fontFamily: "pp2",),
                      prefixIcon: Icon(Icons.watch_later_outlined, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: trajecto,
                    decoration: const InputDecoration(
                      labelText: "Ponto de partida",
                      labelStyle: TextStyle(fontFamily: "pp2",),
                      prefixIcon: Icon(Icons.arrow_upward_rounded, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: onde,
                    decoration: const InputDecoration(
                      labelText: "Ponto de chegada",
                      labelStyle: TextStyle(fontFamily: "pp2",),
                      prefixIcon:
                          Icon(Icons.arrow_downward_rounded, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: preco,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Seu preço (AOA)",
                      labelStyle: TextStyle(fontFamily: "pp2",),
                      prefixIcon: Icon(
                        Icons.attach_money_rounded,
                        size: 15.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  /*  child:  DropDownFormField(
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
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue.shade700),
                      ),
                      onPressed: () {
                        EnviarDados();
                      },
                      child: loaing == false
                          ? const Text(
                              'Anunciar',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "pp2",
                                fontSize: 15.0,
                              ),
                            )
                          : SizedBox(
                              height: 25.0,
                              width: 25.0,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Colors.lightBlueAccent,
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
    );
  }

  getImagem() async {
    final imgTempp = await ImagePicker().getImage(source: ImageSource.gallery);

    if (imgTempp != null) {
      setState(() {
        imagem = File(imgTempp.path);
      });
    }
  }

  getImagemm() async {
    final imgTempp = await ImagePicker().getImage(source: ImageSource.camera);

    if (imgTempp != null) {
      setState(() {
        imagem = File(imgTempp.path);
      });
    }
  }
}

class Ajuda extends StatefulWidget {
  const Ajuda({Key? key}) : super(key: key);

  @override
  State<Ajuda> createState() => _AjudaState();
}

class _AjudaState extends State<Ajuda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Icon(Icons.arrow_back, color: Colors.blue[700]),
          ),
        ),
        leadingWidth: 35.0,
        title: Text(
          'Obter Ajuda',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
            fontFamily: 'pp2'
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Image.asset(
                  'assets/information (2).png',
                  height: 100.0,
                  width: 100.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 14.0, top: 15, right: 14.0),
              child: const Text(
                  'Precisa de ajuda com alguma coisa ? \n Contacta nos enviando um email com a sua dificuldade e responderemos o mais breve possível \n\nEmail: suporte@kulolesa.com \n\n Website: www.kulolesa.com ',
                  style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}

class ComoFunciona extends StatefulWidget {
  const ComoFunciona({Key? key}) : super(key: key);

  @override
  State<ComoFunciona> createState() => _ComoFuncionaState();
}

class _ComoFuncionaState extends State<ComoFunciona> {
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
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Icon(Icons.arrow_back, color: Colors.blue[700]),
          ),
        ),
        leadingWidth: 35.0,
        title: Text(
          'Sobre o aplicativo',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
            fontFamily: 'pp2',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 25),
                  child: Image.asset(
                    'assets/Ku.png',
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Text("Como Funciona a Kulolesa",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 20.0,
                      fontFamily: 'pp2',
                    )),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 25.0),
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: const Text(
                    'Kulolesa é um aplicativo que disponibiliza o app para usuários e vendedores que queiram divulgar seus serviços e para os que queiram encontrar algum serviço de acomodação, Transportes ou actividades. \n\n Na abertura ou cadastro da conta será cadastrado como \"Usuário\" , poderá solicitar a alteraçao de conta no seu perfil e será aprovado o mais rápido possivel.'
                    '\n\nApós o periodo de teste gratuito, será reposto novas políticas de uso em que na qual todos os usuários receberão estas mesma políticas a vigorar apartir da data de recebimento.'
                    '\n\nTodos os serviços presentes no aplicativo não são prestados pela Kulolesa mas sim pelos seus respectivos prestadores cadastrados na plataforma.',
                    style: TextStyle(fontSize: 15.0, fontFamily: 'pp2')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

      if(id == "null"){
        Get.to(() => LoginPage());
      }
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
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("Operation Execute."),
        second: 8,
      );
    }
  }

  Future Alterando() async {
    setState(() {
      processando = true;
    });

    var data = {
      "id": id,
      "nome": nome,
    };

    final res = await http.post(
        Uri.parse("https://kulolesaa.000webhostapp.com/alterar_conta.php"),
        body: data);

    var resultado = jsonDecode(res.body);
    print(resultado);

    if (resultado == "nao") {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.red[300],
        contentText: "Ocorreu um erro técnico ao tentar fazer o pedido alteraração de conta",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("Ocorreu um erro ao executar."),
        second: 8,
      );

      setState(() {
        processando = false;
      });

    } else {

      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 200),
          child: SucessoAG3(),
        ),
      );
      setState(() {
        processando = false;
      });
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
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
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Icon(Icons.arrow_back, color: Colors.blue[700]),
          ),
        ),
        leadingWidth: 35.0,
        title: Text(
          'Alterar estado da conta',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.blue[700],
            fontWeight: FontWeight.w100,
            fontFamily: "pp2"
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
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
                    child: Column(
                      children: const [
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
                    child: Column(
                      children: const [
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
                margin: EdgeInsets.only(top: 20, bottom: 20),
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
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
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
              margin: EdgeInsets.only(top: 40.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),

                  backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
                ),
                onPressed: () => Alterando()  ,
                child: processando == false
                    ? Text(
                        'Solicitar Alteração',
                        style: TextStyle(
                            fontFamily: 'pp2', color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Solicitando... ", style: TextStyle(
                              fontFamily: "pp2")),
                          SizedBox(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.blue.shade700,
                                color: Colors.white),
                            height: 25,
                            width: 25,
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
