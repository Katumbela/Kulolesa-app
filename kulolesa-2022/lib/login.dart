import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulolesaa/Home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_snackbar/timer_snackbar.dart';
import 'Inicial.dart';
import 'PaginaUm.dart';
import 'package:http/http.dart' as http;
import 'criar_conta.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emaill = TextEditingController();
  TextEditingController password = TextEditingController();
  bool processando = false;

  Future login() async {
    setState(() {
      processando = true;
    });

    var data = {
      "email": emaill.text,
      "senha": password.text,
    };

    final res = await http.post(
        Uri.parse("https://kulolesaa.000webhostapp.com/signin_kulolesa.php"),
        body: data);

    var resultado = jsonDecode(res.body);

    if (resultado == "false") {
        timerSnackbar(
          context: context,
          backgroundColor: Colors.red[300],
          contentText: "Email ou palavra passe inválida, tente novamente",
          // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
          buttonLabel: "",
          afterTimeExecute: () => print("Operation Execute."),
          second: 8,
      );

      setState(() {
        processando = false;
      });
    } else {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("login", resultado['id'].toString());
      await pref.setString("nome", resultado['nome'].toString());
      await pref.setString("sobrenome", resultado['sobrenome'].toString());
      await pref.setString("id", resultado['id'].toString());
      await pref.setString("estado", resultado['estado'].toString());
      await pref.setString("telefone", resultado['telefone'].toString());
      await pref.setString("email", resultado['email'].toString());
      await pref.setString("quando", resultado['quando'].toString());
      await pref.setString("foto", resultado['foto'].toString());
      await pref.setString("tudo", resultado.toString());

      setState(() {
        processando = false;
      });
      Get.to(() => HomePage1());
    }
  }

  bool ActiveConnection = false;
  String T = "";
  Future CheckConection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
      });

      timerSnackbar(
        context: context,
        backgroundColor: Colors.orange[300],
        contentText: "Verifique sua conexão com a internet é estável",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("Rede desligada."),
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
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .45,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 12,
                            ),
                          ],
                          color: Colors.blue.shade700,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(195.0),
                            bottomRight: Radius.circular(195.0),
                          )),
                      margin: const EdgeInsets.only(
                        bottom: 28,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              top: 15,
                            ),
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                icon: Icon(Icons.arrow_back_rounded),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * .11),
                              child: const Icon(
                                Icons.person_search_outlined,
                                size: 95,
                                color: Colors.white,
                              )),
                          const Text(
                            'Iniciar Sessão',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'pp2',
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 300,
                            height: 40.0,
                            child: TextFormField(
                              controller: emaill,
                              validator: (value) {
                                if (value == null) return 'insira o email';
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.alternate_email),
                                hintText: 'Insira seu email',
                                hintStyle: TextStyle(
                                  fontFamily: "pp2"
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 40.0,
                            width: 300,
                            margin: EdgeInsets.only(top: 22.0, bottom: 20.0),
                            child: SizedBox(
                              height: 40.0,
                              width: 300,
                              child: TextField(
                                obscureText: true,
                                controller: password,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: 'Insira a senha ',
                                    hintStyle: TextStyle(
                                    fontFamily: "pp2"
                                )
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade700),
                          ),
                          onPressed: () => login(),
                          child: processando == false
                              ? Text(
                                  'Entrar',
                                  style: TextStyle(
                                      fontFamily: 'pp2',
                                      color: Colors.white),
                                )
                              : SizedBox(
                                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.blue.shade700,
                                      color: Colors.white),
                                  height: 25,
                                  width: 25,
                                ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForgotPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                'Não consegue fazer login',
                                style: TextStyle(
                                  fontFamily: 'pp2',
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Não possui uma conta? ",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'pp2',
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType
                                            .leftToRightWithFade,
                                        alignment: Alignment.center,
                                        duration: Duration(milliseconds: 700),
                                        child: CriarConta(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Criar conta',
                                    style: TextStyle(
                                      fontFamily: 'pp2',
                                      fontSize: 12.0,
                                      color: Colors.blue,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutraPagina extends StatefulWidget {
  @override
  _OutraPaginaState createState() => _OutraPaginaState();
}

class _OutraPaginaState extends State<OutraPagina> {
  @override
  Widget build(BuildContext context) {
    return Perfil();
  }
}

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  get key => null;

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
      nome = pref.getString("nome")!.toString();
      id = pref.getString("id")!.toString();
      sobrenome = pref.getString("sobrenome")!.toString();
      estado = pref.getString("estado")!.toString();
      telefone = pref.getString("telefone")!.toString();
      quando = pref.getString("quando")!.toString();
      foto = pref.getString("foto")!.toString();
    });

      if(id == ""){
        Get.to(() => MyHomePage());
      }
  }

  int _indiceAtual = 0; // Variável para controlar o índice das telas
  final List<Widget> _telas = [
    FirstScreen(),
    Favoritos(),
    AddPost(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  late String login;

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
    GetDatas();
      CheckConection();
      estado;

  }

  @override
  Widget build(BuildContext context) {
    void onTabTapped(int index) {
      setState(() {
        _indiceAtual = index;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _telas[_indiceAtual],
      bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),

        child: BottomNavigationBar(
          unselectedItemColor: Colors.black26,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue.shade700,
          selectedLabelStyle: TextStyle(
            color: Colors.blue[700],
            fontFamily: "pp2",
          ),
          unselectedLabelStyle: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
            fontFamily: "pp2",
          ),
          currentIndex: _indiceAtual,
          onTap: onTabTapped,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: ("Inicial"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: ("Favoritos"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add_outlined),
              label: ("Actividades"),
            ),
          ],
        ),
      ),
    );
  }
}

//AREA PARA A PRIMEIRA PAGINA DEPOIS DE ABRIR O APP

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Key? get key => null;

  @override
  void initState() {
    super.initState();
    GetDatas();

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

  String nome = "";
  String id = "";
  String conta = "";

  void GetDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("nome")!;
      id = pref.getString("id")!;
      conta = pref.getString("estado")!;
    });

    String val = pref.getString("id")!;
    if (val == "") {

      if(id == "null"){
        Get.to(() => LoginPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                // foregroundDecoration:  BoxDecoration(
                //   color: Colors.white60,
                // ),
                height: MediaQuery.of(context).size.height * .93,
                child: Image(
                  height: MediaQuery.of(context).size.height * .92,
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    "https://kulolesaa.000webhostapp.com/bgs/bg3.jpeg" ,
                  ),
                ),
                decoration: BoxDecoration(),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.only(left: 25.0, right: 2.0, top: 15.0),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                        return SearchBar();
                      }),);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, left: 15.0, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.4),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        height: 25.0,
                        child: InkWell(
                          child: Text(" Pesquisar ", style: TextStyle(
                            fontFamily: "pp2",)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.white.withOpacity(0.4),
                      ),
                      margin: EdgeInsets.only(
                          /*bottom:  MediaQuery.of(context).size.height * .79,*/ left:
                              20.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 250),
                                child: Perfil()),
                          );
                        },
                        child: Icon(
                          Icons.message,
                          size: 25.0,
                          color: Colors.black45,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .20,
            left: MediaQuery.of(context).size.width * .01,
            right: MediaQuery.of(context).size.width * .01,
            child: Container(
                child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 200),
                            child: Trajeto()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.directions_bus,
                            color: Colors.blue.shade700,
                            size: 20.0,
                            semanticLabel: "Ver Favoritos",
                          ),
                          Text(
                            'Transportes',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "pp2",
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 200),
                            child: AcomodacaoChooseCountry()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.hotel,
                            color: Colors.blue.shade700,
                            size: 20.0,
                          ),
                          Text(
                            "Acomodações",
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "pp2",
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 200),
                            child: HomeScreen()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.explore_outlined,
                            color: Colors.blue.shade700,
                            size: 20.0,
                          ),
                          Text(
                            'Experiências',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "pp2",
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 200),
                            child: DadosPerfil()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.blue.shade700,
                            size: 20.0,
                          ),
                          Text(
                            'Perfil',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "pp2",
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}

//AREA FOR RENEWING THE PASSWORD

class ForgotPassword extends StatefulWidget {
  ForgotPassword(); /* Esse é o creator que vai receber os dados */
  //final String ref;
  //final String descr;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(bottom: 40.0, top: 30.0, left: 15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 40.0,
                  child: Text(
                      'Insira o seu email para receber o código de redefinição da palavra passe',
                      style: TextStyle(
                          fontFamily: "pp2"
                      )),
                ),
              ),
              Container(
                height: 15.0,
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 40.0,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            fontFamily: "pp2"
                        ),
                        contentPadding: EdgeInsets.only(top: 4.0, left: 10.0)),
                  ),
                ),
              ),
              Container(
                height: 25.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blue.shade700),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ConfirmarCodigo()));
                },
                child: Text(
                  'ENVIAR CÓDIGO',
                  style: TextStyle(color: Colors.white, fontFamily: "pp2"),
                ),
              ),

/*
EXEMPLO DO BOTÃO PARA ABRIR O POPUP

          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('AlertDialog Title'),
                content: const Text('AlertDialog description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            child: const Text('Show Dialog'),
          ),
*/
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmarCodigo extends StatefulWidget {
  @override
  _ConfirmarCodigoState createState() => _ConfirmarCodigoState();
}

class _ConfirmarCodigoState extends State<ConfirmarCodigo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      margin:
                          EdgeInsets.only(bottom: 40.0, top: 30.0, left: 10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset('assets/back.png',
                            height: 30.0, width: 30.0),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        height: 40.0,
                        child: Text(
                            'Digite o código de 6 dígitos que lhe enviamos e insira a nova palavra passe'
                            , style: TextStyle(
                            fontFamily: "pp2"
                        )),
                      ),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        height: 40.0,
                        child: TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  fontFamily: "pp2"
                              ),
                              hintText: 'Código de confirmação',
                              contentPadding:
                                  EdgeInsets.only(top: 4.0, left: 10.0)),
                        ),
                      ),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        height: 40.0,
                        child: TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(

                              labelStyle: TextStyle(
                                  fontFamily: "pp2"
                              ),
                              hintText: 'Nova senha',
                              contentPadding:
                                  EdgeInsets.only(top: 4.0, left: 10.0)),
                        ),
                      ),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        height: 40.0,
                        child: TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(

                              labelStyle: TextStyle(
                                  fontFamily: "pp2"
                              ),
                              hintText: 'Confirmar senha',
                              contentPadding:
                                  EdgeInsets.only(top: 4.0, left: 10.0)),
                        ),
                      ),
                    ),
                    Container(
                      height: 25.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[700]),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomePage1()));
                      },
                      child: Text(
                        'ALTERAR',
                        style: TextStyle(color: Colors.white, fontFamily: "pp2"),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 30.0),
                        height: 25.0,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HelpPage()));
                          },
                          child: Text(
                            'Não recebi o código de confirmação',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 150.0),
              child: Image.asset(
                'assets/Ku.png',
                height: 150.0,
                width: 150.0,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 40.0, right: 40.0),
              margin: EdgeInsets.only(bottom: 35.0, top: 35.0),
              child: Text(
                  'Se não consegue fazer login ou receber o código de confirmação, por favor contacte o nosso centro de apoio para dar suporte no seu caso'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue.shade700),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SenhaErrada extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 20.0,
            ),
            Center(
              child: Image.asset(
                'assets/Ku.png',
                height: 180.0,
                width: 180.0,
              ),
            ),
            Container(
                padding: EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                ),
                child: Text(
                  'Email ou Senha errada, os dados inseridos não são compatíveis ',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.red,
                  ),
                )),
            Center(
                child: Text(
              'Tente Novamente',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blue.shade700,
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class Sucesso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 20.0,
            ),
            Center(
              child: Image.asset(
                'assets/Ku.png',
                height: 180.0,
                width: 180.0,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 25.0,
                top: 10.0,
                bottom: 20.0,
                right: 25.0,
              ),
              child: Text(
                ' Bemvindo',
                style: TextStyle(
                  fontSize: 27.0,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                right: 50.0,
                top: 20.0,
                bottom: 20.0,
                left: 50.0,
              ),
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Sua conta foi criada com sucesso, faça login para continuar',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black87,
                    ),
                  )),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue.shade700),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
              child: Text(
                'Faça login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Favoritos extends StatefulWidget {
  const Favoritos({Key? key}) : super(key: key);

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
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


  Future GetFavs() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/get_favs.php");


    var digitadoo = {
      "id": meuid,
    };


    final pesquisarr = await http.post(link, body: digitadoo);
    final ress = jsonDecode(pesquisarr.body);
    print(ress);
    return jsonDecode(pesquisarr.body);
  }

  Future DeleteFavs(id_fav) async{
      print(id_fav + " Id nome ");
  }


  @override

  void initState() {
    super.initState();
    CheckConection();
    GetDatas();
    GetFavs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          "Seus Favoritos ",
          style: TextStyle(
            color: Colors.blue[700],
            fontFamily: "pp2",
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height* .9,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
Container(
  child: FutureBuilder(
    future: GetFavs(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return snapshot.hasData && snapshot.data.toString() != '[]'
          ? Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 35.0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  List dados = snapshot.data;
                  return Dismissible(
                    key: Key(dados[index]["id"]),
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                    ),
                    onDismissed: (direction) async {
                      final removedItem = dados[index];
                      List updatedList = List.from(dados);
                      updatedList.removeAt(index);

                      setState(() {
                        dados = updatedList;
                      });

                      final links = Uri.parse(
                          "https://kulolesaa.000webhostapp.com/delete_favs.php");

                      var digitadoso = {
                        "id_post": removedItem["id"],
                      };

                      final pesquisarsr =
                          await http.post(links, body: digitadoso);
                      final resss = jsonDecode(pesquisarsr.body);
                      print(resss);

                      if (resss == "sim") {
                        timerSnackbar(
                          context: context,
                          backgroundColor: Colors.green[300],
                          contentText: "Removido dos favoritos com sucesso!",
                          buttonLabel: "",
                          afterTimeExecute: () => print("Operation Execute."),
                          second: 8,
                        );
                      } else {
                        setState(() {
                          dados.insert(index, removedItem);
                        });

                        timerSnackbar(
                          context: context,
                          backgroundColor: Colors.red[300],
                          contentText:
                              "Ocorreu um erro ao tentar remover dos favoritos, tente novamente mais tarde!",
                          buttonLabel: "",
                          afterTimeExecute: () => print("Operation Execute."),
                          second: 8,
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .25,
                            height: MediaQuery.of(context).size.height * .15,
                            child: Image(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                'https://kulolesaa.000webhostapp.com/' +
                                    dados[index]['servico'] +
                                    '/' +
                                    dados[index]['foto'],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dados[index]['obs'],
                                  style: TextStyle(
                                    fontFamily: "pp2",
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "AOA",
                                        style: TextStyle(
                                          fontFamily: "pp2",
                                          fontSize: 8,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        dados[index]['preco'],
                                        style: TextStyle(
                                          fontFamily: "pp2",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.red[50],
                                        borderRadius:
                                            BorderRadius.circular(40),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.favorite_sharp,
                                              size: 14, color: Colors.red[800]),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 4, right: 1),
                                            child: Text(
                                              'Favorito',
                                              style: TextStyle(
                                                color: Colors.red[800],
                                                fontFamily: "pp2",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                              .22,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .1),
                  child: Center(
                    child: Image.asset(
                      "assets/fav.webp",
                      height: MediaQuery.of(context).size.height * .4,
                      width: MediaQuery.of(context).size.width * .4,
                    ),
                  ),
                ),
                Text(
                  "Vazio!",
                  style: TextStyle(
                    fontFamily: "pp2",
                  ),
                ),
              ],
            );
    },
  ),
)

               ],
            ),
          ),
        ),
      ),
    );
  }
}


class EscolherConta extends StatefulWidget {
  const EscolherConta({Key? key}) : super(key: key);

  @override
  State<EscolherConta> createState() => _EscolherContaState();
}

class _EscolherContaState extends State<EscolherConta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .3, bottom: 40.0),
              child: Image.asset(
                "assets/Ku.png",
                height: 120,
                width: 120,
              ),
            ),
            Column(
              children: <Widget>[
                Center(
                  child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 40.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        width: MediaQuery.of(context).size.width * .9,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Usuário",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )),
                ),
                Center(
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400),
                            child: CriarContaVendedor(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        height: 40.0,
                        width: MediaQuery.of(context).size.width * .9,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Vendedor",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddPost extends StatefulWidget {
  var UserId;
  AddPost({this.UserId});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String nome = "";
  String id = "";
  String estado = "";
  String sobrenome = "";
  String conta = "";

  TextEditingController Actividade = new TextEditingController();
  TextEditingController descricao = new TextEditingController();
  TextEditingController local = new TextEditingController();
  TextEditingController preco = new TextEditingController();
  TextEditingController espaco = new TextEditingController();
  bool loaing = false;
  File? imagem;

  late String _myActivity;
  late String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  _saveForm() {
    setState(() {
      _myActivityResult = _myActivity;
    });
  }

  Future EnviarDados() async {
    setState(() {
      loaing = true;
    });
    print(_myActivity);

    final uri = Uri.parse("https://kulolesaa.000webhostapp.com/add_act.php");

    var request = http.MultipartRequest('POST', uri);
    request.fields["descricao"] = descricao.text;
    request.fields["localizacao"] = local.text;
    request.fields["act"] = Actividade.text;
    request.fields["preco"] = preco.text;
    request.fields["conta"] = id;
    request.fields["pro"] = "LUANDA";
    var pic = await http.MultipartFile.fromPath("image", imagem!.path);
    request.files.add(pic);
    var resposta = await request.send();

    if (resposta.statusCode != 402) {
      CoolAlert.show(
        context: context,
        title: "Adicionado com sucesso",
        backgroundColor: Colors.green.shade100,
        type: CoolAlertType.success,
        confirmBtnColor: Colors.blue.shade700,
        text: "O seu anuncio está em revisão, será notificado em breve",
      );

      setState(() {
        loaing = false;
      });
    } else if (resposta == "erro") {
      CoolAlert.show(
        context: context,
        title: "Erro ao anunciar",
        backgroundColor: Colors.red.shade100,
        autoCloseDuration: Duration(seconds: 6),
        type: CoolAlertType.error,
        confirmBtnColor: Colors.blue.shade700,
        text: "Ocorreu um erro ao publicitar o seu anuncio",
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
        text: "Por favor preencha os campos vazios",
      );
    }

    setState(() {
      loaing = false;
    });
  }



  void GetDatass() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nome = pref.getString("nome").toString();
      sobrenome = pref.getString("sobrenome").toString();
      estado = pref.getString("estado").toString();
      id = pref.getString("id")!;
      conta = pref.getString("tipo").toString();
    });

    if (estado == "Usuario") {
        Get.to(() => AlterarConta());
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
    _myActivityResult = '';

      CheckConection();


    GetDatass();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          "Adicionar actvidade ou serviço",
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.blue[700],
            fontFamily: "pp2",
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
                                            color: Colors.blue[700], size: 45.0
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
                                            color: Colors.blue[700], size: 45.0
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0)),
                                  Text("Ilustração da Actividade", style: TextStyle(

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
                    controller: Actividade,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9\.]"))],
                    decoration: const InputDecoration(
                        labelText: "Actividade",
                        labelStyle: TextStyle(fontFamily: "pp2"),
                        prefixIcon: Icon(
                          Icons.explore_outlined,
                          size: 15.0,
                        )),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: descricao,
                    decoration: const InputDecoration(
                      labelText: "Descrição da actividade ",
                      labelStyle: TextStyle(fontFamily: "pp2"),
                      prefixIcon: Icon(Icons.edit_note_rounded, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: local,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))],
                    decoration: const InputDecoration(
                      labelText: "Local",
                      labelStyle: TextStyle(fontFamily: "pp2"),
                      prefixIcon: Icon(Icons.location_on_outlined, size: 15.0),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: preco,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                    decoration: InputDecoration(
                        labelText: "Preço ",
                        labelStyle: TextStyle(fontFamily: "pp2"),
                        prefixIcon: Icon(Icons.attach_money, size: 15.0)),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 15.0),
                //   child: DropDownFormField(
                //     titleText: 'Província',
                //     hintText: 'Selecionar...',
                //     value: _myActivity,
                //     onSaved: (value) {
                //       setState(() {
                //         _myActivity = value;
                //       });
                //     },
                //     onChanged: (value) {
                //       setState(() {
                //         _myActivity = value;
                //       });
                //     },
                //     dataSource: const [
                //       {
                //         "display": "LUANDA",
                //         "value": "LUANDA",
                //       },
                //       {
                //         "display": "CABINDA",
                //         "value": "CABINDA",
                //       },
                //       {
                //         "display": "BENGUELA",
                //         "value": "BENGUELA",
                //       },
                //       {
                //         "display": "MOXICO",
                //         "value": "MOXICO",
                //       },
                //       {
                //         "display": "MALANJE",
                //         "value": "MALANJE",
                //       },
                //       {
                //         "display": "KWANZA SUL",
                //         "value": "KWANZA SUL",
                //       },
                //       {
                //         "display": "CUNENE",
                //         "value": "CUNENE",
                //       },
                //     ],
                //     textField: 'display',
                //     valueField: 'value',
                //   ),
                // ),
                Center(
                  child: estado == "Vendedor" ? Container(
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
                  ) :     Container(
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 350),
                                child: AlterarConta(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Text(
                                "Solicite primeiro a alteração de conta para poder anunciar no Kulolesa", textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "pp2",
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Text("Ganhe dinheiro com o seu transporte", style: TextStyle(fontFamily: "pp2")),
                  ),
                ),
                estado == "Vendedor" ? Container(
                    child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 350),
                          child: Transpp(),
                        ),
                      );
                    },
                    child: Text(
                      "anunciar agora",
                      style: TextStyle(
                        fontFamily: "pp2",
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                )) : Text(""),
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

class AcomodacaoChoose extends StatefulWidget {
  var pais;
  AcomodacaoChoose({this.pais});




  @override
  State<AcomodacaoChoose> createState() => _AcomodacaoChooseState();
}

class _AcomodacaoChooseState extends State<AcomodacaoChoose> {
  String id = "";
  String conta = "";
  String nome = "";

  Future Cidades() async {
    final link = Uri.parse("https://kulolesaa.000webhostapp.com/cidades.php");
    var digitadoo = {
      "pais": widget.pais,
    };

    final pesquisarr = await http.post(link, body: digitadoo);
    final ress = jsonDecode(pesquisarr.body);
    print(ress);
    return jsonDecode(pesquisarr.body);
  }


  @override
  void initState() {
    super.initState();
    Cidades();
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
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.only( left: 10.0, right: 10.0),
              child: Column(



                children: <Widget>[



                  Container(
                    padding: EdgeInsets.only(top: 35, left: 0.0, right: 15.0),
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child:
                      Icon(Icons.arrow_back_rounded, color: Colors.black),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 15.0),
                    alignment: Alignment.topLeft,
                    child: Text("Escolheu " + widget.pais, style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 30,
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    )),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: 0, left: 15.0),
                    alignment: Alignment.topLeft,
                    child: Text("Apresentamos-lhe as cidades de " + widget.pais + "", style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                      fontFamily: "pp2",
                    )),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.topToBottom,
                          duration: Duration(milliseconds: 100),
                          child: SearchBar(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .02, left: 15.0, right: 15.0),
                      alignment: Alignment.topLeft,

                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[700], ),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text("Pesquisar", style: TextStyle(

                              color: Colors.grey[700],
                              fontFamily: "pp2",
                            )),
                          ),
                        ]
                      ),
                    ),
                  ),  ///termino da area de pesquisa pra ir pesquisar acomodacao


                  Container(
                    width:  MediaQuery.of(context).size.width ,
                    height: MediaQuery.of(context).size.height * .5,
                    child:  FutureBuilder(
                      future: Cidades(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView.builder(
                              itemCount: snapshot.data.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                var cidade = snapshot.data[index]['cidade'];
                                var pais = snapshot.data[index]['pais'];
                                var foto_c = snapshot.data[index]['foto'];
                                return Padding(
                                  padding: EdgeInsets.all(5),
                                  child:  Card(
                                    elevation: 0,
                                    shadowColor: Colors.blue[700],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            duration: Duration(milliseconds: 350),
                                            child: Acomodacao(prov: cidade, pais: pais),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height:
                                              MediaQuery.of(context).size.height * .13,
                                              width:
                                              MediaQuery.of(context).size.width * .45,
                                              child:  Image(

                                                height:
                                                MediaQuery.of(context).size.height * .13,
                                                width:
                                                MediaQuery.of(context).size.width * .45,
                                                fit: BoxFit.cover,
                                                image: CachedNetworkImageProvider(
                                                  'https://kulolesaa.000webhostapp.com/cidades/' +
                                                      foto_c,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                top: 5.0,
                                              ),
                                              child: Text(
                                                "Acomodações em", textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: "pp2",
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                cidade,
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "pp2",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                        return Center(child: CircularProgressIndicator());
                      },
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




class AcomodacaoChooseCountry extends StatefulWidget {
  const AcomodacaoChooseCountry({Key? key}) : super(key: key);

  @override
  State<AcomodacaoChooseCountry> createState() => _AcomodacaoChooseCountryState();
}

class _AcomodacaoChooseCountryState extends State<AcomodacaoChooseCountry> {
  String id = "";
  String conta = "";
  String nome = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(

              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30, left: 10.0),
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child:
                    Icon(Icons.arrow_back_rounded, color: Colors.black),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .02,
                      left: 25.0),
                  alignment: Alignment.topLeft,
                  child: Text("Escolha o país", style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: "pp2",
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .0,
                      bottom: MediaQuery.of(context).size.height * .0,
                      left: 25.0),
                  alignment: Alignment.topLeft,
                  child: Text("Comece por escolher o país onde procura uma acomodação", style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: "pp2",
                    fontSize: 14,
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
                        child: SearchBar(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .02, left: 20.0, right: 20.0, bottom: 10),
                    alignment: Alignment.topLeft,

                    child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[700], ),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text("Pesquisar", style: TextStyle(

                              color: Colors.grey[700],
                              fontFamily: "pp2",
                            )),
                          ),
                        ]
                    ),
                  ),
                ),  ///termino da area de pesquisa pra ir pesquisar acomodacao

                Container(
                  width: MediaQuery.of(context).size.width * 85,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        shadowColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 350),
                                child:  AcomodacaoChoose(pais: "Angola"),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height * .15,
                                  width:
                                  MediaQuery.of(context).size.height * .22,
                                  child: Image.asset(
                                    "assets/angolaa.webp",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        shadowColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 350),
                                child:  AcomodacaoChoose(pais:"Portugal"),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height * .15,
                                  width:
                                  MediaQuery.of(context).size.height * .22,
                                  child: Image.asset(
                                    "assets/portugal.jpeg",
                                    fit: BoxFit.cover,
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
                Container(
                  width: MediaQuery.of(context).size.width * 85,
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        shadowColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 350),
                                child:  AcomodacaoChoose(pais: "Mozambique"),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height * .15,
                                  width:
                                  MediaQuery.of(context).size.height * .22,
                                  child: Image.asset(
                                    "assets/moz_b.jpeg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        shadowColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 350),
                                child:  AcomodacaoChoose(pais: "Brazil"),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height * .15,
                                  width:
                                  MediaQuery.of(context).size.height * .22,
                                  child: Image.asset(
                                    "assets/bazil_b.png",
                                    fit: BoxFit.cover,
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
                Container(
                  width: MediaQuery.of(context).size.width * 85,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        shadowColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 350),
                                child: AcomodacaoChoose(pais: "Cabo Verde"),
                              ),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height * .15,
                                  width:
                                  MediaQuery.of(context).size.height * .22,
                                  child: Image.asset(
                                    "assets/cabo.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(

                        height:
                        MediaQuery.of(context).size.height * .15,
                        width:
                        MediaQuery.of(context).size.height * .22,
                      ),
                    ],
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
