import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../models/sponsored_models.dart';
import '../models/user_provider.dart';
import '../models/usuariosModel.dart';

class DetalhesTransportePage extends StatefulWidget {
  final TodosTranspModel transporte;
  final  heroTag;

  const DetalhesTransportePage({super.key, required this.heroTag, required this.transporte});

  @override
  State<DetalhesTransportePage> createState() => _DetalhesTransportePageState();
}

class _DetalhesTransportePageState extends State<DetalhesTransportePage> {
  Future<void> _showAgendamentoDialog(BuildContext context) async {
    int numeroDeLugares = 1;
    DateTime? dataPartida;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Efectuar Reserva'),
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
              // ElevatedButton(
              //   onPressed: () => _selectedDate(context),
              //   child:  DataFormatada != ""
              //       ? Text(DataFormatada.toString(), textAlign: TextAlign.center,  style: TextStyle(color: Colors.grey[800], fontSize: 15.0,
              //     fontFamily: "pp2",
              //   ),)
              //       : Text("Escolha a Data", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800], fontSize: 15.0,
              //     fontFamily: "pp2",
              //   ),),
              // ),
              Container(
                child: Row(
                  children: [
                    Text("Pagamento: "),
                    Text("Em Espécie", style: TextStyle(
                      fontWeight: FontWeight.w800,
                    )),
                  ],
                ),
              ),

              // Container(
              //   margin: EdgeInsets.only(top: 6),
              //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              //
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16),
              //     color: Colors.grey[200],
              //   ),
              //   child: InkWell(
              //     onTap: () => _selectedDate(context),
              //     child:  DataFormatada != ""
              //         ? Text(DataFormatada.toString(), textAlign: TextAlign.center,  style: TextStyle(color: Colors.grey[800], fontSize: 15.0,
              //       fontFamily: "pp2",
              //     ),)
              //         : Text("Escolha a Data", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800], fontSize: 15.0,
              //       fontFamily: "pp2",
              //     ),),
              //   ),
              // ),
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

                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 250),
                      child:  SucessoAG(titulo: "Seu agendamento"),
                    ),
                  );
                } catch (error) {
                  Navigator.pop(context); // Fechar o indicador de carregamento
                  _showErrorAlert(context, error.toString());
                }
              },
              child: const Text('Reservar'),
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
              Text('Salvando reserva...'),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveAgendamento(int numeroDeLugares, DateTime? dataPartida) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;


    // Implemente a lógica para salvar os dados no Firestore aqui
    try {
      await FirebaseFirestore.instance.collection('agendamentos').add({
        'numero_de_lugares': numeroDeLugares,
        'idUsuario': userData!.uniqueID,
        'idServico': widget.transporte.id,
        'contaVendedor': widget.transporte.conta,
        'data_partida': '-------',
        'transporte': widget.transporte.nome,
        'servico': 'transporte',
        'quando': DateTime.now(),
        'preco': widget.transporte.preco,
      });

      Navigator.pop(context); // Fechar o indicador de carregamento

      await FirebaseFirestore.instance.collection('notificacoes').add({
        'para': widget.transporte.conta,
        'conteudo': "${userData!.fullName.split(" ")[0]} fez uma reserva de $numeroDeLugares lugares no seu transporte "+ widget.transporte.nome + " abra a app e entre em contacto com ${userData!.fullName}",
        'nome': userData!.fullName,
        'foto': userData!.profilePic,
        'status': 'pendente',
        'lido': false,// Você pode adicionar mais campos conforme necessário
        'quando': FieldValue.serverTimestamp(), // Para registrar a data e hora do pedido
      });

      // Supondo que 'lugares' seja a chave para o número de lugares na tabela de transportes
      var transportRef = FirebaseFirestore.instance.collection('transportes').doc(widget.transporte.id);

      int lugaresDisponiveis = 0;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(transportRef);
        lugaresDisponiveis = int.parse(snapshot['lugares']);
      });


      int lugaresReservados = numeroDeLugares;
      int lugaresRestantes = lugaresDisponiveis - lugaresReservados;

      if (lugaresRestantes < 0) {
        // Você pode adicionar tratamento para lidar com lugares insuficientes
        // Por exemplo, mostrar uma mensagem de erro ao usuário
        print('Lugares insuficientes');
      } else {
        // Atualiza o número de lugares disponíveis na tabela de transportes
        await transportRef.update({'lugares': lugaresRestantes.toString()});
      }



      // await FirebaseFirestore.instance.collection('notificacoes').add({
      //   'para': userData!.uniqueID,
      //   'conteudo': "Fez uma reserva de $numeroDeLugares lugares no transporte "+ widget.transporte.nome,
      //   'nome': userData!.fullName,
      //   'status': 'pendente',
      //   'lido': false,// Você pode adicionar mais campos conforme necessário
      //   'quando': FieldValue.serverTimestamp(), // Para registrar a data e hora do pedido
      // });

      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 250),
          child:  SucessoAG(titulo: "Seu agendamento"),
        ),
      );



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
          content: const Text('Reserva salvo com sucesso!'),
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


  String DataFormatada = "";
  DateTime tgl = DateTime.now();
  DateTime now = DateTime.now();
  final TextStyle valueStyle = const TextStyle(fontSize: 16.0);


  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(2022),
        lastDate: DateTime(2050));

    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        if(tgl.isBefore(now)){
          // timerSnackbar(
          //   context: context,
          //   backgroundColor: Colors.red[500],
          //   contentText: "Escolha uma data a partir de hoje",
          //   // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
          //   buttonLabel: "",
          //   afterTimeExecute: () => print('acionado'),
          //   second: 8,
          // );
        }
        else{
          DataFormatada = DateFormat.yMEd().format(tgl);
          print(tgl);
        }

      });
    } else {}
  }

  List<UsuarioModel> usuarios = [];

  Future<void> fetchUsuarios() async {
    List<UsuarioModel> fetchedUsuarios = await UsuarioModel.getUsuarios();
    setState(() {
      usuarios = fetchedUsuarios;
    });
  }

  List<ReviewsAcomModel> comentariosFiltrados = [];

  void pegarComments() async {
    // Obter a lista de comentários do Firestore
    List<ReviewsAcomModel> comentarios = await ReviewsAcomModel.getReviewAcom(widget.transporte.id);

    // Filtrar os comentários que correspondem à acomodação atual
    comentariosFiltrados = comentarios.toList();
  }



// Função para formatar a data
  String formatarData(DateTime data) {
    final dateFormat = DateFormat("d MMM y, HH:i");
    return dateFormat.format(data);
  }

  @override
  Widget build(BuildContext context) {

    fetchUsuarios();
    pegarComments();


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
                      tag: widget.heroTag+"wedw", // Tag deve ser a mesma usada no ListTile anterior
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade500,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * .1,
                        height: MediaQuery.of(context).size.height * .9,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Container(
                            width: 40,  // Defina o tamanho desejado
                            height: 40, // Defina o tamanho desejado
                            child: CachedNetworkImage(
                              imageUrl: widget.transporte.img,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 30, // Tamanho do CircularProgressIndicator
                                  height: 30, // Tamanho do CircularProgressIndicator
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
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
                    const SizedBox(height: 20.0),
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

                    const SizedBox(height: 10.0),
                    Row(
                      children: [

                        Icon(Icons.people_alt_outlined,),
                        const SizedBox(width:4.0),
                        Text(
                          'Disponível ',
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        Text(
                          ' ${widget.transporte.lugares} lugares ',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined,),
                        const SizedBox(width:4.0),
                        Text(
                          'Parte em ',
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        Text(
                          ' ${widget.transporte.dataPartida} ',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Preço: ${widget.transporte.preco} Kz / lugar',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 23.0),
                    Divider(
                      thickness: 1,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 23.0),
                    const Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(widget.transporte.descricao),
                    const SizedBox(height: 16.0),

                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .9,
                        child: ElevatedButton(
                          onPressed: () {
                            _showAgendamentoDialog(context);
                          },
                          child: const Text('Reservar'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),


                    // Exibir comentários da acomodação
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


                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Navigator.push(
                    //     //   context,
                    //     //   MaterialPageRoute(builder: (context) => AgendamentosPage()),
                    //     // );
                    //   },
                    //   child: const Text('Meus Agendamentos'),
                    // ),

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
