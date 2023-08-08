import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login.dart';

class Mensagens extends StatefulWidget {
  var id, preco, marca, quanto, onde, para, user, telefone;
  Mensagens(
      {this.id,
      this.quanto,
      this.marca,
      this.para,
      this.onde,
      this.telefone,
      this.user});
  @override
  _MensagensState createState() => _MensagensState();
}

bool processando = false;

class _MensagensState extends State<Mensagens> {
  TextEditingController msg = new TextEditingController();

  late num telefone_v;

  void GetDatass() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("toke")!;
      id = pref.getString("id")!;
      conta = pref.getString("tipo")!;
    });

    String val = pref.getString("id")!;
    if (val == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  String id = "";
  String conta = "";
  String nome = "";
  String sobrenome = "";
  String email = "";
  String telefone = "";

  void getNumber() async {
    final linkk = Uri.parse("http://kulolesa.000webhostapp.com/pegar_user.php");
    var dado = {
      "id": widget.user,
    };

    final resultado_resp = await http.post(linkk, body: dado);
    final tel_r = jsonDecode(resultado_resp.body);

    setState(() {
      telefone_v = tel_r['telefone']!;
    });
  }

  @override
  void initState() {
    super.initState();
    getNumber();
    GetDatass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_rounded)),
        title: Center(
          child: Row(
            children: <Widget>[
              Text(
                widget.marca,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          InkWell(
              onTap: () async {
                launch('tel://');
                await FlutterPhoneDirectCaller.callNumber(widget.telefone);
              },
              child: Icon(Icons.settings_phone_rounded)),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Container(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(''),
                          Text(''),
                          Text('Vai para ' + widget.para),
                          Text(''),
                          Text('Preco: ' + widget.quanto + " AOA"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * .01,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      height: 45.0,
                      child: TextField(
                        controller: msg,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              top: 0,
                              bottom: 7.0,
                              left: 20.0,
                            ),
                            hintText: 'Escrever mensgem',
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      height: 3.0,
                      width: 8.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 4.0),
                      child: InkWell(
                          onTap: () {
                            SendMsg();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.lightBlue,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SendMsg() async {
    final url = Uri.parse("http://kulolesa.000webhostapp.com/sendmsg.php");

    var dados = {
      "de": id,
      "nome": nome,
      "id": widget.id,
      "msg": msg.text,
      "para": widget.user,
      "tipo": widget.marca,
    };

    final res = await http.post(url, body: dados);
    var resposta = jsonDecode(res.body);
    print(resposta);
  }
}

class Mensagens2 extends StatefulWidget {
  var id, preco, foto, disp, quem, espaco;
  Mensagens2(
      {this.id, this.quem, this.espaco, this.disp, this.foto, this.preco});

  @override
  _Mensagens2State createState() => _Mensagens2State();
}

bool processando2 = false;

class _Mensagens2State extends State<Mensagens2> {
  TextEditingController msg = new TextEditingController();

  void GetDatass() async {
    print(widget.quem);
    print(widget.id);
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("toke")!;
      id = pref.getString("id")!;
      conta = pref.getString("tipo")!;
      estado = pref.getString("tipo")!;
      sobrenome = pref.getString("tipo")!;
    });

    String val = pref.getString("id")!;
    if (val == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  String id = "";
  String conta = "";
  String nome = "";
  String sobrenome = "";
  String estado = "";

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
        backgroundColor: Colors.lightBlue,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_rounded)),
        title: Center(
          child: Row(
            children: <Widget>[
              Text(
                widget.espaco,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          /* InkWell(
              onTap: () async {
                const num = "";
                launch('tel://$num');
                await FlutterPhoneDirectCaller.callNumber(num);
              },
              child: Icon(Icons.settings_phone_rounded)),*/
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Container(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(''),
                          Text(''),
                          Text('Reserva: ' + widget.espaco),
                          Text(''),
                          Text('Preco: ' + widget.preco + " AOA"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * .01,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      height: 45.0,
                      child: TextField(
                        controller: msg,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              top: 0,
                              bottom: 7.0,
                              left: 20.0,
                            ),
                            hintText: 'Escrever mensgem',
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      height: 3.0,
                      width: 8.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 4.0),
                      child: InkWell(
                          onTap: () {
                            SendMsg();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.lightBlue,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SendMsg() async {
    final url = Uri.parse("http://kulolesa.000webhostapp.com/sendmsg2.php");

    var dados = {
      "de": id,
      "nome": nome,
      "id": widget.id,
      "msg": msg.text,
      "para": widget.quem,
      "tipo": widget.espaco,
    };

    final res = await http.post(url, body: dados);
    var resposta = jsonDecode(res.body);
    print(resposta);
  }
}

class Msg3 extends StatefulWidget {
  const Msg3({Key? key}) : super(key: key);

  @override
  State<Msg3> createState() => _Msg3State();
}

class _Msg3State extends State<Msg3> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
