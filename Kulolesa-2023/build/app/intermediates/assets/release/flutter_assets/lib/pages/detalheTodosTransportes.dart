import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/models/sponsored_models.dart';


class DetalheTodosTransportes extends StatefulWidget {
  final TodosTranspModel transporte;
  final String heroTag;

  const DetalheTodosTransportes({super.key,required this.heroTag, required this.transporte});

  @override
  State<DetalheTodosTransportes> createState() => _DetalheTodosTransportesState();
}

class _DetalheTodosTransportesState extends State<DetalheTodosTransportes> {
  Future<void> _showAgendamentoDialog(BuildContext context) async {
    int numeroDeLugares = 1;
    DateTime? dataPartida;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agendamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Número de Lugares'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  numeroDeLugares = int.parse(value);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (selectedDate != null) {
                    dataPartida = selectedDate;
                  }
                },
                child: Text(
                  dataPartida == null
                      ? 'Escolher Data de Partida'
                      : 'Data de Partida: ${dataPartida!.day}/${dataPartida!.month}/${dataPartida!.year}',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Fechar o diálogo antes de mostrar o indicador de carregamento
                _showLoadingIndicator(context);

                try {
                  await _saveAgendamento(numeroDeLugares, dataPartida);
                  Navigator.pop(context); // Fechar o indicador de carregamento
                  _showSuccessAlert(context);
                } catch (error) {
                  Navigator.pop(context); // Fechar o indicador de carregamento
                  _showErrorAlert(context, error.toString());
                }
              },
              child: const Text('Agendar'),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Salvando agendamento...'),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveAgendamento(int numeroDeLugares, DateTime? dataPartida) async {
    // Implemente a lógica para salvar os dados no Firestore aqui
    try {
      await FirebaseFirestore.instance.collection('agendamentos').add({
        'numero_de_lugares': numeroDeLugares,
        'data_partida': dataPartida,
      });
    } catch (error) {
      rethrow;
    }
  }

  void _showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Agendamento salvo com sucesso!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorAlert(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text('Erro ao salvar o agendamento: $errorMessage'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: widget.heroTag, // Tag deve ser a mesma usada no ListTile anterior
                      child: Container(
                        width: MediaQuery.of(context).size.width * .1,

                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(widget.transporte.img),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // child:ClipRRect(
                        //   borderRadius: BorderRadius.circular(15),
                        //   child: SizedBox.fromSize(
                        //     size: Size.fromRadius(
                        //         MediaQuery.of(context).size.height * .25),
                        //     child: Image.asset(
                        //       widget.transporte.img,
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.transporte.sponsor == true ? Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2) ,
                      decoration: BoxDecoration(color: EstiloApp.primaryColor.withOpacity(.3),
                        border:Border.all(color: Colors.blueGrey, width: 1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text("Patrocinado", style: TextStyle(fontWeight: FontWeight.w400),),
                    ) :
                    const Text(""),
                    Text(
                      widget.transporte.nome,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 4.0),
                        Text(widget.transporte.local),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.arrow_downward_rounded),
                        const SizedBox(width: 4.0),
                        Text(widget.transporte.destino),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Preço: ${widget.transporte.preco} Kz',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Descrição do Transporte:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(widget.transporte.nome),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _showAgendamentoDialog(context);
                      },
                      child: const Text('Agendar'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => AgendamentosPage()),
                        // );
                      },
                      child: const Text('Meus Agendamentos'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
