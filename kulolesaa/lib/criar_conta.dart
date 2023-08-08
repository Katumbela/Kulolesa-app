import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_snackbar/timer_snackbar.dart';
import 'dart:ui';
import 'auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'login.dart';

class CriarConta extends StatefulWidget {
  const CriarConta();

  @override
  _CriarConta createState() => _CriarConta();
}

class _CriarConta extends State<CriarConta> {
  TextEditingController nome = TextEditingController();
  TextEditingController sobrenome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telefone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nascimento = TextEditingController();

  bool log = false;
  bool processando = false;

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
    Timer.periodic(Duration(seconds: 15), (timer) {
      CheckConection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: Container(
          alignment: Alignment.topLeft,
          child: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: Colors.blue.shade700,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        title: Text(
          'Dados Pessoais',
          style: TextStyle(
            color: Colors.blue.shade700,
            fontSize: 38.0,
            fontWeight: FontWeight.bold,
            fontFamily: "pp2"
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 18.0),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.blue,
                                blurRadius: 14.0,
                              ),
                            ],
                          ),
                          child: Icon(Icons.person_add_alt,
                              size: 50, color: Colors.white)),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              controller: nome,
                              keyboardType: TextInputType.text,

                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, size: 20),
                                labelText: ' Nome',
                                  labelStyle: TextStyle(
                                  fontFamily: "pp2"
                              )
                              ),
                            )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              controller: sobrenome,
                              keyboardType: TextInputType.text,

                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, size: 20),
                                labelText: ' Sobrenome',
                                  labelStyle: TextStyle(
                                      fontFamily: "pp2"
                                  )
                              ),
                            )),
                      ),
                    ),

                    /*   Center(

                      child: Container(
                        width: MediaQuery.of(context).size.width * .8,
                          child: Genero(),
                      ),
                    ),

                  */

                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              controller: telefone,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                              ],
                              maxLength: 13,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone, size: 20),
                                labelText: ' Telefone',
                                  labelStyle: TextStyle(
                                      fontFamily: "pp2"
                                  )
                              ),
                            )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.alternate_email, size: 20),
                                labelText: ' Email',
                                  labelStyle: TextStyle(
                                      fontFamily: "pp2"
                                  )
                              ),
                            )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              obscureText: true,
                              controller: password,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outlined, size: 20),
                                labelText: 'Palavra Passe',
                                  labelStyle: TextStyle(
                                      fontFamily: "pp2"
                                  )
                              ),
                            )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .05,
                            bottom: 20.0),
                        width: MediaQuery.of(context).size.width * .8,
                        height: 45.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade700),
                          ),
                          onPressed: () {
                            CadastrarConta();
                          },
                          child: processando == false
                              ? Text(
                                  'Criar Conta',
                                  style: TextStyle(fontSize: 20.0,
                                    fontFamily: "pp2",),
                                )
                              : SizedBox(
                                  height: 26.0,
                                  width: 26.0,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.blue.shade600,
                                    color: Colors.white,
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
      ),
    );
  }

  //metodo para fazer uo cadastro da pessoa a usar a conta

  Future CadastrarConta() async {
    Future.delayed(const Duration(milliseconds: 2000), () {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Termos de Uso', style: TextStyle(
            fontFamily: "pp2",)),
          content: const SingleChildScrollView(
            child: Text(
                'Para usufruir de algumas funcionalidades, o usuário poderá precisar efetuar um cadastro, criando uma conta de usuário com login e senha próprios para acesso.'
                '\n\n Toda e qualquer publicação de serviço deverá ser revisado primerio antes de ser apresentado para potenciais usuários e só depois da revisão será aprovado ou negado de estar no aplicativo.'
                '\n\n É de total responsabilidade do usuário fornecer apenas informações corretas, autênticas, válidas, completas e atualizadas, bem como não divulgar o seu login e senha para terceiros.'
                '\n\n Partes deste aplicativo oferecem ao usuário a opção de publicar feedbacks e serviços em campos dedicados. Kulolesa não consente com publicações discriminatórias, ofensivas ou ilícitas, ou ainda infrinjam direitos de autor ou quaisquer outros direitos de terceiros.'
                '\n\n A publicação de quaisquer conteúdos pelo usuário deste aplicativo, incluindo, mas não se limitando, a  serviços e feedbacks, implica licença não-exclusiva, irrevogável e irretratável, para sua utilização, reprodução e publicação pela Kulolesa em seu aplicativo, plataformas e aplicações de internet, ou ainda em outras plataformas, sem qualquer restrição ou limitação.'
          , style: TextStyle(
          fontFamily: "pp2",),),),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Recusar',
              style: TextStyle(
      fontFamily: "pp2"
      )),
            ),
            TextButton(
              onPressed: () {
                criarC();
                Navigator.pop(context);
              },
              child: const Text('Aceitar',
                  style: TextStyle(
                      fontFamily: "pp2"
                  )),
            ),
          ],
        ),
      );
    });

    setState(() {
      processando = true;
    });
  }

  criarC() async {
    var data = {
      "nome": nome.text,
      "snome": sobrenome.text,
      "telefone": telefone.text,
      "email": email.text,
      "senha": password.text,
    };

    final res = await http.post(
        Uri.parse("https://kulolesaa.000webhostapp.com/signup_kulolesa.php"),
        body: data);

    print(res.body);

    final tudo = jsonDecode(res.body);

    if (tudo != "false") {
      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight,
              duration: Duration(milliseconds: 300),
              child: LoginPage()),
        );
      });

      setState(() {
        processando = false;
      });
      CoolAlert.show(
        context: context,
        title: "Sucesso",
        backgroundColor: Colors.green.shade100,
        autoCloseDuration: Duration(seconds: 2),
        type: CoolAlertType.success,
        confirmBtnColor: Colors.blue.shade700,
        text: "Sua conta foi criada com sucesso " + nome.text,
      );
    }
  }
}

class CriarContaVendedor extends StatefulWidget {
  const CriarContaVendedor({Key? key}) : super(key: key);

  @override
  State<CriarContaVendedor> createState() => _CriarContaVendedorState();
}

class _CriarContaVendedorState extends State<CriarContaVendedor> {
  TextEditingController nome = TextEditingController();
  TextEditingController sobrenome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telefone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nascimento = TextEditingController();

  bool log = false;
  bool processando = false;

  late String _myActivity;
  late String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  _saveForm() {
    setState(() {
      _myActivityResult = _myActivity;
    });
  }

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
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
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_rounded),
                          color: Colors.blue.shade700,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0, top: 0.0),
                      padding: EdgeInsets.only(left: 15.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Dados Pessoais',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 38.0,
                          fontFamily: "pp2",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 30.0),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(Icons.person_add_alt,
                              size: 50, color: Colors.white)),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              controller: nome,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, size: 20),
                                labelText: ' Nome',
                              ),
                            ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              controller: sobrenome,
                              keyboardType: TextInputType.text,

                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, size: 20),
                                labelText: ' Sobrenome',
                              ),
                            ),
                          ),
                        ),
                      ),

                    /*   Center(

                      child: Container(
                        width: MediaQuery.of(context).size.width * .8,
                          child: Genero(),
                      ),
                    ),

                  */

                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              controller: telefone,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                              ],
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone, size: 20),
                                labelText: ' Telefone',
                              ),
                            )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.alternate_email, size: 20),
                                labelText: ' Email',
                              ),
                            )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              obscureText: true,
                              controller: password,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outlined, size: 20),
                                labelText: 'Palavra Passe',
                              ),
                            )),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 15.0),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .1),
                        width: MediaQuery.of(context).size.width * .8,
                        height: 35.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade700),
                          ),
                          onPressed: () {
                            CadastrarConta();
                          },
                          child: processando == false
                              ? Text(
                                  'Criar Conta',
                                  style: TextStyle(fontSize: 20.0,
                                    fontFamily: "pp2",),
                                )
                              : SizedBox(
                                  height: 30.0,
                                  width: 30.0,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.blue.shade500,
                                    color: Colors.white,
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
      ),
    );
  }

  Future CadastrarConta() async {
    Future.delayed(const Duration(milliseconds: 2000), () {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Termos de uso', style: TextStyle(
            fontFamily: "pp2",)),
          content: const Text(
              'Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade Termos ou politias de privacidade, ler termos ou políticas de privacidade '),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Recusar'),
            ),
            TextButton(
              onPressed: () {
                criarC();
                Navigator.pop(context);
              },
              child: const Text('Aceitar'),
            ),
          ],
        ),
      );
      setState(() {
        processando = false;
      });
    });

    setState(() {
      processando = true;
    });
  }

  criarC() async {
    var data = {
      "nome": nome.text,
      "snome": sobrenome.text,
      "telefone": telefone.text,
      "email": email.text,
      "senha": password.text,
    };

    final res = await http.post(
        Uri.parse("https://kulolesaa.000webhostapp.com/signup_kulolesa.php"),
        body: data);

    print(res.body);

    final tudo = jsonDecode(res.body);

    if (res.body == "true") {
      Future.delayed(const Duration(milliseconds: 2500), () {
        Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 300),
              child: LoginPage()),
        );
      });
    }

    if (res.body == "false") {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.red[300],
        contentText:
            "Ocorreu um erro ao cadastrar sua conta, verifique os campos e tente novamente!",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("Operation Execute."),
        second: 8,
      );
    }
  }
}

//area de escolher o genero do usuario

class Genero extends StatefulWidget {
  @override
  _GeneroState createState() => _GeneroState();
}

enum GeneroUsuario { Masculino, Feminino }

class _GeneroState extends State<Genero> {
  GeneroUsuario _GeneroGrupo = GeneroUsuario.Masculino;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: Radio(
            value: GeneroUsuario.Masculino,
            activeColor: Colors.lightBlue,
            toggleable: true,
            groupValue: _GeneroGrupo,
            onChanged: (GeneroUsuario? value) {
              setState(() {
                _GeneroGrupo = value!;
              });
            },
          ),
        ),
        Text('Masculino'),
        Container(
          child: Radio(
            value: GeneroUsuario.Feminino,
            activeColor: Colors.lightBlue,
            toggleable: true,
            groupValue: _GeneroGrupo,
            onChanged: (GeneroUsuario? value) {
              setState(() {
                _GeneroGrupo = value!;
              });
            },
          ),
        ),
        Text('Feminino'),
      ],
    );
  }
}

class TipoDeConta extends StatefulWidget {
  @override
  _TipoDeContaState createState() => _TipoDeContaState();
}

enum Conta { Usuario, Vendedor }

class _TipoDeContaState extends State<TipoDeConta> {
  Conta _estado = Conta.Usuario;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Radio(
            value: Conta.Usuario,
            activeColor: Colors.lightBlue,
            toggleable: true,
            groupValue: _estado,
            onChanged: (Conta? value) {
              setState(() {
                _estado = value!;
              });
            },
          ),
        ),
        Text('Usuário'),
        Container(
          child: Radio(
            value: Conta.Vendedor,
            activeColor: Colors.lightBlue,
            toggleable: true,
            groupValue: _estado,
            onChanged: (Conta? value) {
              setState(() {
                _estado = value!;
              });
            },
          ),
        ),
        Text('Vendedor'),
      ],
    );
  }
}

//area do datepicker

class DetailsScrenn extends StatefulWidget {
  @override
  _DetailsScrennState createState() => _DetailsScrennState();
}

class _DetailsScrennState extends State<DetailsScrenn> {
  late DateTime _myDateTime;
  late String time;
  late String datass;
  TextEditingController _nascimento = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 300,
        height: 38.0,
        child: TextFormField(
          controller: _nascimento,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_today_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: 'Nascimento',
            contentPadding: EdgeInsets.only(top: 2.5),
          ),
          onTap: () async {
            _myDateTime = (await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1980),
              lastDate: DateTime(2025),
            ))!;

            setState(() {
              time = DateFormat('dd / MM / yyyy').format(_myDateTime);
              _nascimento.text = time;
            });
          },
        ),
      ),
    );
  }
}
