import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/models/sponsored_models.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'models/user_provider.dart';
import 'models/usuariosModel.dart';

class DetalheActividades extends StatefulWidget {
  final TodasActividadesModel actividade;
  final String heroTag;

  const DetalheActividades(
      {super.key, required this.heroTag, required this.actividade});

  @override
  State<DetalheActividades> createState() => _DetalheActividadesState();
}

class _DetalheActividadesState extends State<DetalheActividades> {
  DateTime? dataReserva;

  //
  // Future<void> _selectEntryDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: entryDate ?? DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2050),
  //   );
  //
  //   if (picked != null && picked != entryDate) {
  //     setState(() {
  //       entryDate = picked;
  //     });
  //   }
  // }
  //


  List<UsuarioModel> usuarios = [];
  List<ReviewsAcomModel> comentariosFiltrados = [];

  Future<void> fetchUsuarios() async {
    List<UsuarioModel> fetchedUsuarios = await UsuarioModel.getUsuarios();
    setState(() {
      usuarios = fetchedUsuarios;
    });
  }

  void pegarComments() async {
    // Obter a lista de comentários do Firestore
    List<ReviewsAcomModel> comentarios = await ReviewsAcomModel.getReviewAcom(widget.actividade.id);

    // Filtrar os comentários que correspondem à acomodação atual
    comentariosFiltrados = comentarios.toList();
  }

  Future<void> _selectReservaDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataReserva ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != dataReserva) {
      setState(() {
        dataReserva = picked;
      });
    }
  }

  Future<void> _showAgendamentoDialog(BuildContext context) async {
    int numeroDeLugares = 1;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agendamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Número de Lugares'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  numeroDeLugares = int.parse(value);
                },
              ),
              const SizedBox(height: 16),
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
                Navigator.pop(
                    context); // Fechar o diálogo antes de mostrar o indicador de carregamento
                _showLoadingIndicator(context);

                try {
                  await _saveAgendamento(numeroDeLugares, dataReserva);
                } catch (error) {
                  Navigator.pop(context); // Fechar o indicador de carregamento
                  _showErrorAlert(context, error.toString());
                  return; // Não execute o restante do código em caso de erro
                }

                // O diálogo de sucesso será tratado dentro da função _saveAgendamento
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
              Text('Salvando sua reserva...'),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveAgendamento(
      int numeroDeLugares, DateTime? dataPartida) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    try {
      await FirebaseFirestore.instance.collection('agendamentos').add({
        'atividade': widget.actividade.actividade,
        'local': widget.actividade.local,
        'preco': widget.actividade.preco,
        'idServico': widget.actividade.id,
        'idUsuario': userData!.uniqueID,
        'descricao': widget.actividade.descricao,
        'numero_de_lugares': numeroDeLugares,
        'contaVendedor': widget.actividade.conta,
        'servico': "Actividade",
        'data_partida': dataPartida,
        'quando': DateTime.now(),
      });

      await FirebaseFirestore.instance.collection('notificacoes').add({
        'para': widget.actividade.conta,
        'conteudo':
            "${userData!.fullName.split(" ")[0]} fez uma reserva em ${widget.actividade.actividade}, para  $dataPartida para $numeroDeLugares lugar(es), abra a app e entre em contacto com ${userData!.fullName}",
        'nome': userData!.fullName,
        'status': 'pendente',
        'foto': userData!.profilePic,
        'lido': false, // Você pode adicionar mais campos conforme necessário
        'quando': FieldValue
            .serverTimestamp(), // Para registrar a data e hora do pedido
      });

      // Fechar o diálogo de carregamento e exibir o diálogo de sucesso
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 200),
          child: SucessoAG(
              titulo: "Sua reserva para ${widget.actividade.actividade}"),
        ),
      );
    } catch (error) {
      // Fechar o diálogo de carregamento e exibir o diálogo de erro
      Navigator.pop(context); // Fechar o indicador de carregamento
      _showErrorAlert(context, error.toString());
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
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchUsuarios();
    pegarComments();
    // _selectReservaDate();
  }


// Função para formatar a data
  String formatarData(DateTime data) {
    final dateFormat = DateFormat("d MMM y");
    return dateFormat.format(data);
  }
  @override
  Widget build(BuildContext context) {
    // _selectReservaDate();

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
                      tag: "act_" +
                          widget
                              .heroTag, // Tag deve ser a mesma usada no ListTile anterior
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade500,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * .1,
                        height: MediaQuery.of(context).size.height * .8,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Container(
                            width: 40, // Defina o tamanho desejado
                            height: 40, // Defina o tamanho desejado
                            child: CachedNetworkImage(
                              imageUrl: widget.actividade.img,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width:
                                      30, // Tamanho do CircularProgressIndicator
                                  height:
                                      30, // Tamanho do CircularProgressIndicator
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
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
                    widget.actividade.sponsor == true
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: EstiloApp.primaryColor.withOpacity(.3),
                              border:
                                  Border.all(color: Colors.blueGrey, width: 1),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Text(
                              "Patrocinado",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          )
                        : const Text(""),
                    Text(
                      widget.actividade.actividade,
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
                        Text(widget.actividade.local),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text(
                          'Preço:',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          ' ${widget.actividade.preco} Kz',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Descrição da actividade:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(widget.actividade.descricao),
                    const SizedBox(height: 16.0),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Pagamento",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Em espécie",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    Text("Escolha a data",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                    ),

                    const SizedBox(height: 16.0),

                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () => _selectReservaDate(),
                        child: dataReserva != null
                            ? Text(
                                DateFormat.yMEd().format(dataReserva!),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue[800],
                                  fontSize: 15.0,
                                ),
                              )
                            : Text(
                                "Marque a data",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue[800],
                                  fontSize: 15.0,
                                  fontFamily: "",
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 26.0),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Navigator.push(
                    //     //   context,
                    //     //   MaterialPageRoute(builder: (context) => AgendamentosPage()),
                    //     // );
                    //   },
                    //   child: const Text('Meus Agendamentos'),
                    // ),


                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: comentariosFiltrados.isNotEmpty
                          ? const Text(
                        "Avaliações de clientes",
                        style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      )
                          : const Text(""),
                    ),
                    Column(
                      children: comentariosFiltrados.map((comentario) {
                        UsuarioModel usuario =
                        usuarios.firstWhere((user) => user.id == comentario.quemId);

                        return Container(
                          width: MediaQuery.of(context).size.width * 10,
                          margin:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.01),
                                    blurRadius: 5,
                                    spreadRadius: 1),
                              ]),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(30.0),
                                  child: CachedNetworkImage(
                                    imageUrl: usuario.foto,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * .5,
                                          child: Text(
                                            usuario.nome,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(comentario.rating.toString(),  style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      ],
                                    ),
                                    Text(comentario.coment),
                                    const SizedBox(height: 6),
                                    Text(
                                      comentario.data,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Container(
                child: Row(
                  children: [
                    Text(
                      "AOA ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "" + widget.actividade.preco,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 105,
                height: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: () {
                    _showAgendamentoDialog(context);
                  },
                  child: Text(
                    'Reservar',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
