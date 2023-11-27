import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/app_bar.dart';

class PromotionPage extends StatefulWidget {
  final String serviceId;
  final String serviceType;
  final String nome;

  PromotionPage({required this.serviceId, required this.serviceType, required this.nome});

  @override
  _PromotionPageState createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  int numberOfDays = 0;
  double totalAmount = 0.0;
  bool paymentSubmitted = false;
  File? selectedComprovativo;

  void calculateTotalAmount() {
    const pricePerDay = 950;
    setState(() {
      totalAmount = numberOfDays * pricePerDay.toDouble();
    });
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;


  void submitPayment() async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (selectedComprovativo != null) {
      final Reference storageRef =
      _storage.ref().child('comprovativos/${DateTime.now()}.jpg'); // Replace with the appropriate file extension
      final UploadTask uploadTask = storageRef.putFile(selectedComprovativo!);

      await uploadTask.whenComplete(() async {
        final String comprovativoUrl = await storageRef.getDownloadURL();

        // Now, update Firestore with the comprovativo link
        try {
          await FirebaseFirestore.instance.collection('promocoes').add({
            'serviceId': widget.serviceId,
            'nomeServico': widget.nome,
            'tipoServico': widget.serviceType,
            'comprovativoUrl': comprovativoUrl,
            'numberOfDays': numberOfDays,
            'totalAmount': totalAmount,
            'status': 'revisão', // You can set the initial status here
            'timestamp': FieldValue.serverTimestamp(),
          });

          Navigator.of(context).pop();

          setState(() {
            paymentSubmitted = true;
            numberOfDays = 0;
            totalAmount = 0.0;
            selectedComprovativo = null;
          });
        } catch (error) {
          // Handle Firestore update error
          print(' $error');

          Navigator.of(context).pop();
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Promover Serviço"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Text(
              'Promover ${widget.nome}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.0),

            Container(
              alignment: Alignment.topLeft,
                child: Text('Dias de promoção:'),
            ),

            SizedBox(
              height: 20,
            ),

          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Aceitar apenas números
            onChanged: (value) {
              numberOfDays = int.tryParse(value) ?? 0;
              calculateTotalAmount();
            },
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



            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total: ',style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                Text(' ${totalAmount.toStringAsFixed(2)} Kz',style: TextStyle(
                    fontWeight: FontWeight.w800,
                  fontSize: 18,
                  ),
                ),
              ],
            ),
            if (!paymentSubmitted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  selectedComprovativo == null ? TextButton(
                    onPressed: () async {
                      final XFile? image = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );

                      if (image != null) {
                        setState(() {
                          selectedComprovativo = File(image.path);
                        });
                      } else {
                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                        if (result != null) {
                          setState(() {
                            selectedComprovativo = File(result.files.single.path!);
                          });
                        }
                      }
                    },
                    child: Text('Adicionar Comprovativo'),
                  ) : SizedBox.shrink(),

                  if (selectedComprovativo != null)
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        )
                        ,
                        Text('Comprovativo selecionado', style: TextStyle(
                          color: Colors.green,
                        )),
                        Icon(Icons.check_circle_outline_rounded, color: Colors.green,size: 26)
                      ],
                    ),

                  SizedBox(height: 16.0),

                  if (selectedComprovativo != null)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .4,
                        child: ElevatedButton(
                        onPressed: () {
                          // Implement logic to submit payment
                          submitPayment();
                        },
                        child: Text('Submeter Promoção'),
                    ),
                      ),

                  SizedBox(height: 16.0),
                ],
              ),

            if (paymentSubmitted)
                Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10
                  ),
                  Icon(Icons.check, size: 40, color: Colors.green),
                  Center(
                    child: Text(
                      'Comprovativo e promoção submetidos com sucesso. Aguarde aprovação.',
                      textAlign: TextAlign.center,style: TextStyle(color: Colors.green),
                    ),
                  ),
                  SizedBox(
                      height: 15
                  ),
                ],
              ),

            // Center(
            //   child: ElevatedButton(
            //     onPressed: paymentSubmitted
            //         ?  () {
            //       // Implement logic to submit promotion
            //       submitPromotion();
            //     } : null,
            //     child: Text('Submeter Promoção'),
            //   ),
            // ),

          ],
        ),
      ),
    );
  }
}
