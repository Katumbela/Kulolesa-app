import 'package:flutter/material.dart';

class PesquisarAcomodacao extends StatelessWidget {
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController dataFimController = TextEditingController();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Verifica se uma data foi selecionada
      controller.text =
          picked.toString(); // Atualiza o texto no controlador de texto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospedagens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, left: 5, right: 5),
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 54,
              decoration: ShapeDecoration(
                color: Color(0x47E1E1E1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: TextField(
                controller: cidadeController,
                decoration: InputDecoration(
                  hintText: 'Insira uma cidade, ponto de inter...',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, dataInicioController),
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 54,
                      decoration: ShapeDecoration(
                        color: Color(0x47E1E1E1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        controller: dataInicioController,
                        decoration: InputDecoration(
                          hintText: 'Data de entrada',
                          border: InputBorder.none,
                        ),
                        enabled: false,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, dataFimController),
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 54,
                      decoration: ShapeDecoration(
                        color: Color(0x47E1E1E1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        controller: dataFimController,
                        decoration: InputDecoration(
                          hintText: 'Data de saída',
                          border: InputBorder.none,
                        ),
                        enabled: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Ação quando o botão for pressionado
              },
              child: Text('Buscar hospedagens'),
            ),
          ],
        ),
      ),
    );
  }
}
