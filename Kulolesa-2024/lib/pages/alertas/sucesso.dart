import 'package:flutter/material.dart';
import 'package:kulolesa/pages/inicio.dart';

class SucessoAG extends StatefulWidget {


  final titulo;
  const SucessoAG({super.key, required this.titulo});

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
            const SizedBox(
              height: 140.0,
            ),
            Center(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  child: const Icon(Icons.check_circle_outline_sharp, color: Colors.white, size: 130)
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(

                    child: Text("${widget.titulo} foi submetido com sucesso!", textAlign: TextAlign.center, style: const TextStyle(
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
                        builder: (BuildContext context) => const Inicio(),
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
