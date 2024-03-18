import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/pages/PaginaTransp.dart';

class PesquisarTransporte extends StatelessWidget {
  // Controladores para os campos de entrada
  final TextEditingController _ondeController = TextEditingController();
  final TextEditingController _partidaController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_sharp),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  'Buscar Carros',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    height: 0,
                    letterSpacing: 0.85,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 54,
            decoration: ShapeDecoration(
              color: Color(0x47E1E1E1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: TextField(
              controller: _partidaController,
              decoration: InputDecoration(
                hintText: 'Partida ',
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 54,
            decoration: ShapeDecoration(
              color: Color(0x47E1E1E1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: TextField(
              controller: _ondeController,
              decoration: InputDecoration(
                hintText: 'Onde ?',
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 54,
            decoration: ShapeDecoration(
              color: Color(0x47E1E1E1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: IgnorePointer(
                child: TextFormField(
                  controller: _dataController,
                  decoration: InputDecoration(
                    hintText: 'Selecionar Data',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: InkWell(
              onTap: () {
                // Aqui você pode lidar com a ação do botão de pesquisa
                // Por exemplo, você pode usar os valores dos controladores
                print('Pesquisar carros');
                print('Onde: ${_ondeController.text}');
                print('Data: ${_dataController.text}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginaTransportes(
                      onde: _ondeController.text,
                      data: _dataController.text,
                      partida: _partidaController.text,
                    ),
                  ),
                );
              },
              child: Container(
                height: 56,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Pesquisar carros',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      height: 0,
                      letterSpacing: 0.85,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      _dataController.text = formattedDate;
    }
  }
}
