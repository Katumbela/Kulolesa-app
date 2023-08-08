import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'PaginaUm.dart';
import 'msgs.dart';


class EmpresaY extends StatefulWidget {
  @override
  _EmpresaYState createState() => _EmpresaYState();
}

class _EmpresaYState extends State<EmpresaY> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Stack(
            children: [

          //container da parte de cima ou seja onde contem todos os dados da empresa em questao


              SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 15.0),
                    margin: EdgeInsets.only(
                      top: 255.0,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child:
                    Column(
                      children: [
                        Text('Nossos Serviços'),

                        Container(
                          margin: EdgeInsets.all(15.0),
                          child: Text('DADOS E/OU SERVIÇOS DA EMPRESA '),
                        ),
                      ],
                    )
                ),
              ),



        Container(
        alignment: Alignment.centerLeft,
          height: 260.0,
          padding: EdgeInsets.only(top: 5, left: 20),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.only(
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  <Widget>[

              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(bottom: 15.0, top: 30.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                   },
                  child: Icon(Icons.arrow_back_rounded, color: Colors.white,)
                ),
              ),



              Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 15.0,),
          child:
              Text('Its Kulolesa', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
                color: Colors.white,
                 ),
                ),
              ),

              Container(
                child:
                    Row(

                      children: [

                        Icon(Icons.location_on, color: Colors.white),

                        Text(' - LUANDA', style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                      ],
                    ),

              ),

              Container(
                child:Row(

                  children: [

                    Icon(Icons.watch_later_outlined, color: Colors.white),

                    Text(' - 6h - 18h ', style: TextStyle(
                      color: Colors.white,
                    ),
                    ),
                  ],
                ),
              ),

              Container(
                child:Row(

                  children: [

                    Icon(Icons.miscellaneous_services_outlined, color: Colors.white),

                    Text(' - Servços ', style: TextStyle(
                      color: Colors.white,
                    ),
                    ),
                  ],
                ),
              ),

                  Container(
                  height: 5.0,
                    margin: EdgeInsets.all(9.0),
                  ),

                  Center(

                  child:
InkWell(

  onTap: () {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds:700),
          child: Mensagens()),
    );

  },
    child: Icon(Icons.send_outlined, color: Colors.white,)
),
              ),


                     ],
                 ),
              ),


            ],
          ),
      );
  }
}


class JanelaCarros extends StatefulWidget {
  @override
  _JanelaCarrosState createState() => _JanelaCarrosState();
}

class _JanelaCarrosState extends State<JanelaCarros> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(

            children: [

                 Container(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 15.0),
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .7,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child:
                      Column(
                        children: [
                          Text('Descrição do producto serviço fornecido pelo fornecedor ao publicar este anuncio, dados estes que lhes serão pedidos ao efectuar esta acção ', style: TextStyle(
                            fontSize: 18.0,
                          ),),
                      Container(
                        height: 30.0,
                      ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => Mensagens()),);
                              },
                              child: Text('Contactar', style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),) ,
                            ),
                          )
                        ],
                      )
                  ),
                ),


              //container da parte de cima ou seja onde contem todos os dados da empresa em questao

              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height * .5,
                  padding: EdgeInsets.only(top: 5, left: 20),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  <Widget>[

                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 5.0, top: 30.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => TransPort()),);
                          },

                          child: Icon(Icons.arrow_back_rounded, color: Colors.white),
                        ),
                      ),





                      Container(
                        margin: EdgeInsets.only(top: 15.0, bottom: 8.0,),
                        child:
                        Text('RANGER ROVER 2017', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23.0,
                          color:Colors.white,
                        ),
                        ),
                      ),

                      Container(
                        height: 10.0,
                      ),

                      Container(
                        child: Row(
                      children: [
                            Icon(Icons.person_outlined, color: Colors.white,),

                            Text('  Kulolesa App', style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                     ),
                             ),
                         ],
                      )

                      ),

                    ],
                  ),
                ),
              ),


              Center(
                child: Container(
                  width: 340.0,
                  height: 180.0,
                  margin: EdgeInsets.only(top:  0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(70.0),
                        child: Image.asset('assets/car2.jpeg', fit: BoxFit.cover,),
                      ),
                    ),
                  ),
              ),
              

            ],
      ),
    );
  }
}

