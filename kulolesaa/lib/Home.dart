import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'criar_conta.dart';
import 'login.dart';

class PaginaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: NetworkImage(
                        'https://scontent.flad7-1.fna.fbcdn.net/v/t1.15752-9/274471160_687427616004319_7898060424184842219_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=ae9488&_nc_eui2=AeG0EYX_b7nRDI65LR_3AJI3SIniGddimI5IieIZ12KYjhDoxnz0-oEp_He8QAZYpH7kNihFxW8BvORmblUvDP7e&_nc_ohc=b89R4NCfR6UAX9U_upA&_nc_ht=scontent.flad7-1.fna&oh=03_AVKMtDVMyeUHlc5-1XjkHDXI6rFfWmzTFq0KEqQKLzmTAw&oe=623C59F7'),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LoginPage(),
                                      ),
                                   );
                                },
                              child: Text(
                                'INICIAR SESSÃO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "pp2",
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CriarConta()));
                            },
                            child: Text(
                              'CRIAR CONTA',
                              style: TextStyle(color: Colors.white,
                                fontFamily: "pp2",),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
