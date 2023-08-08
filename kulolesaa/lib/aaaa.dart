import 'dart:convert';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:kulolesaa/criar_conta.dart';
import 'package:http/http.dart' as http;
import 'package:kulolesaa/new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_snackbar/timer_snackbar.dart';

class AddF extends StatefulWidget {
  @override
  State<AddF> createState() => _AddFState();
}

class _AddFState extends State<AddF> {
  File? img;
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
      nome = pref.getString("nome")!;
      id = pref.getString("id")!;
      sobrenome = pref.getString("sobrenome")!;
      estado = pref.getString("estado")!;
      telefone = pref.getString("telefone")!;
      quando = pref.getString("quando")!;
      foto = pref.getString("foto")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text("Alterar foto de perfil"),
      ),
      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width * .9,
              child: img != null
                  ? Center(
                      child: Container(
                        child: Image.file(img!),
                      ),
                    )
                  : Center(child: Text("Nenhuma imagem selecionada")),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.all(20)),
        Container(
          child: Center(
            child: img != null
                ? ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[700]),
                    ),
                    onPressed: () => salvar(),
                    child: processando == false
                        ? Center(
                            child: Text(
                              'Salvar',
                              style: TextStyle(
                                  fontFamily: 'roboto', color: Colors.white),
                            ),
                          )
                        : Container(
                      width: 500.0,
                      child: Row(
                        children: [
                          Center(
                            child: Text(
                              "Salvando foto...",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.blue[700]),
                            height: 25,
                            width: 25,
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(20.0),
                    child: MaterialButton(
                      color: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        getImage();
                      },
                      child: const Text(
                        "Escolher foto",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),
        )
      ]),
    );
  }

  getImage() async {
    final imgTempp = await ImagePicker().getImage(source: ImageSource.gallery);

    if (imgTempp != null) {
      setState(() {
        img = File(imgTempp.path);
      });
    }
  }
  Future salvar() async {
    print(id);
    setState(() {
      processando = true;
    });

    final uri = Uri.parse("http://kulolesaa.000webhostapp.com/add_p.php");

    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id;
    var pic = await http.MultipartFile.fromPath('image', img!.path);
    request.files.add(pic);

    var resposta = await request.send();

    if (resposta.statusCode == 200) {
      timerSnackbar(
        context: context,
        backgroundColor: Colors.green[400],
        contentText: "Sua foto foi carregada com sucesso, aguardando aprovação",
        // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
        buttonLabel: "",
        afterTimeExecute: () => print("Operation Execute."),
        second: 8,
      );
// Atualizar a foto no SharedPreferences
final SharedPreferences pref = await SharedPreferences.getInstance();
final String nomeFoto = img!.path.split('/').last; // Extrair apenas o nome do arquivo da foto
await pref.setString("foto", nomeFoto);

      setState(() {
        processando = false;
      });
    }
  }

}
