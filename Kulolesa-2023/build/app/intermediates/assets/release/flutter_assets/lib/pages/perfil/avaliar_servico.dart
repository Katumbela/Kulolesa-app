
  import 'dart:io';
  import 'package:flutter_rating_bar/flutter_rating_bar.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
  import 'package:kulolesa/widgets/app_bar.dart';
import 'package:page_transition/page_transition.dart';
  import 'package:timer_snackbar/timer_snackbar.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:provider/provider.dart';
  import 'package:kulolesa/widgets/app_bar.dart';
  import 'package:timer_snackbar/timer_snackbar.dart';

  import '../../models/provider.dart';
  import '../../models/user_provider.dart';


  class Review extends StatefulWidget {
    var idServico, tipoServico, nome;

    Review({ required this.nome,  required this.idServico, required this.tipoServico});

    @override

    State<Review> createState() => _ReviewState();
  }

  class _ReviewState extends State<Review> {

    TextEditingController rev_text = new TextEditingController();
    TextEditingController revText = TextEditingController();
    double? _ratingValue;
    bool isLoading = false;


    Future<void> addReview() async {
      setState(() {
        isLoading = true;
      });

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final userData = userProvider.user;

        final reviewsCollection = FirebaseFirestore.instance.collection('reviews');

        await reviewsCollection.add({
          'idAcom': widget.idServico,
          'data': DateTime.now().toString(), // Change this to the desired date format
          'servico': widget.tipoServico,
          'quemId': userData!.uniqueID, // Assuming you have a userId in your userData
          'coment': revText.text,
          'boxColor': const Color(0xff98c8ff).value.toString(),
          'rating': _ratingValue,
        });

        setState(() {
          isLoading = false;
          revText.clear();
          _ratingValue = null;
        });


        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 300),
            child:  SucessoAG(titulo: "Sua avaliação ",),
          ),
        );


        // Show a success snackbar
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text("!"),
        //     duration: Duration(seconds: 3),
        //   ),
        // );
      } catch (error) {
        print('Error sending review: $error');
        setState(() {
          isLoading = false;
        });

        // Show an error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Erro ao enviar avaliação. Tente novamente."),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    @override
    void initState() {
      super.initState();
    }


    @override
    Widget build(BuildContext context) {
      return  Scaffold(
          appBar: CustomAppBar(titulo: "Avaliar Serviço"),
          body: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 24,
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
                      child: Text("Avaliar  " + widget.nome, style: TextStyle(

                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      )),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  //   child: Container(
                  //     child: Text("Efectuou este agendamento no dia ${dia} de ${mes} de ${ano}, as ${hora}h:${min}min", style: TextStyle(
                  //       fontFamily: "pp2",
                  //       fontSize: 15,
                  //       color: Colors.grey[700],
                  //     )),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Container(
                      child: Text("Conte como foi sua experiencia neste serviço, como você avalia este serviço ?", style: TextStyle(
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
                        controller: revText,
                        maxLines: null,
                        maxLength: 400,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFD9D9D9), // Cor de fundo cinza claro
                          border: InputBorder.none, // Sem bordas
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none, // Sem bordas ao focar
                            borderRadius: BorderRadius.circular(16.0), // Raio de borda arredondada
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none, // Sem bordas
                            borderRadius: BorderRadius.circular(16.0), // Raio de borda arredondada
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
                        // ... Rest of your code ...
                        onPressed: () {
                          addReview();
                        },
                        child: isLoading == true
                            ? SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.blue[700],
                          ),
                        )
                            : Row(
                          children: [
                            Spacer(),
                            Text(
                              'Enviar',
                              style: TextStyle(
                                // color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Icon(Icons.send_outlined, size: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      );
    }
  }

