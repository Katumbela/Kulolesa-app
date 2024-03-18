import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/models/meus_servicos_model/meus_servicos_model.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
import 'package:kulolesa/pages/perfil/paginas_meus_servicos/promover_servico.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/sponsored_models.dart';
import '../../../models/user_provider.dart';
import '../../../models/usuariosModel.dart';
import '../avaliar_servico.dart';


class DetalhesTodosMeusTransportesPage extends StatefulWidget {
  final TodosMeusTransportes transporte;
  final  heroTag;

  const DetalhesTodosMeusTransportesPage({super.key, required this.heroTag, required this.transporte});

  @override
  State<DetalhesTodosMeusTransportesPage> createState() => _DetalhesTodosMeusTransportesPageState();
}

class _DetalhesTodosMeusTransportesPageState extends State<DetalhesTodosMeusTransportesPage> {


  List<MeusAgendamentos> agendamentos = [];
  bool _isLoading = true;

  void _getMeusAgendamentos() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    String yourUniqueID = userData!.uniqueID;
    List<MeusAgendamentos> meusAgendamentos =
    await MeusAgendamentos.getTodosMeusAgendamentos(widget.transporte.id);

    setState(() {
      agendamentos = meusAgendamentos;
      _isLoading = false;
    });
  }


  List<TodosTranspModel> todosTranspList = [];
  List<TodasActividadesModel> todasActividadesList = [];
  List<PatrocinadosAcomModel> patrocinadosAcomList = [];

  void getDados() async {
    // Preencha as listas de detalhes usando as funções de busca
    todosTranspList = await TodosTranspModel.getAllTransp();
    todasActividadesList = await TodasActividadesModel.getAllActivities();
    patrocinadosAcomList = await PatrocinadosAcomModel.getSponsoredAcom();
  }


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
            // ElevatedButton(
            //   onPressed: () async {
            //     Navigator.pop(context); // Fechar o diálogo antes de mostrar o indicador de carregamento
            //     _showLoadingIndicator(context);
            //
            //     try {
            //       await _saveAgendamento(numeroDeLugares, dataPartida);
            //       Navigator.pop(context); // Fechar o indicador de carregamento
            //
            //       Navigator.push(
            //         context,
            //         PageTransition(
            //           type: PageTransitionType.fade,
            //           duration: const Duration(milliseconds: 250),
            //           child:  SucessoAG(titulo: "Seu agendamento"),
            //         ),
            //       );
            //     } catch (error) {
            //       Navigator.pop(context); // Fechar o indicador de carregamento
            //       _showErrorAlert(context, error.toString());
            //     }
            //   },
            //   child: const Text('Reservar'),
            // ),
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

  Future<void> _deleteService() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog from being dismissed
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aguarde'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('A eliminar o serviço...'),
              ],
            ),
          );
        },
      );

      await FirebaseFirestore.instance.collection('transportes').doc(widget.transporte.id).delete();

      // Close the loading dialog
      Navigator.pop(context);

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sucesso'),
            content: Text('O serviço foi eliminado com sucesso!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the success dialog
                  Navigator.pop(context); // Close the detail page after deletion
                },
                child: Text('Fechar'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle error here
      print('Error deleting service: $error');
    }
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
        'conteudo': "Fez uma reserva de $numeroDeLugares lugares no seu transporte "+ widget.transporte.nome + " abra a app e entre em contacto com ${userData!.fullName}",
        'nome': userData!.fullName,
        'status': 'pendente',
        'lido': false,// Você pode adicionar mais campos conforme necessário
        'quando': FieldValue.serverTimestamp(), // Para registrar a data e hora do pedido
      });

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

  void _showPromoErro(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ups'),
          content: Text('As promoções encontram se indisponíveis no momento'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
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
  List<ReviewsAcomModel> comentariosFiltrados = [];


  void pegarComments() async {
    // Obter a lista de comentários do Firestore
    List<ReviewsAcomModel> comentarios = await ReviewsAcomModel.getReviewAcom(widget.transporte.id);

    // Filtrar os comentários que correspondem à acomodação atual
    comentariosFiltrados = comentarios.toList();
  }

  Future<void> fetchUsuarios() async {
    List<UsuarioModel> fetchedUsuarios = await UsuarioModel.getUsuarios();
    setState(() {
      usuarios = fetchedUsuarios;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMeusAgendamentos();
    getDados();
    pegarComments();
    fetchUsuarios();
  }


  // Função para fazer a chamada telefônica
  _makePhoneCall(String phoneNumber) async {
    bool? isSuccessful = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (!isSuccessful!) {
      print('Erro ao fazer a chamada.');
    }
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
                      tag: "traanss", // Tag deve ser a mesma usada no ListTile anterior
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade500,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.transporte.img,
                            fit: BoxFit.cover,
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
                    const SizedBox(height: 16.0),
                    Text(
                      'Preço: ${widget.transporte.preco} Kz',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 23.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Show confirmation dialog before deleting
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Confirmação'),
                                  content: Text('Tem certeza que deseja remover este serviço?'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close the dialog
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteService(); // Call the delete function
                                        Navigator.pop(context); // Close the dialog
                                      },
                                      child: Text('Remover'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text("Remover"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PromotionPage(
                                  nome: widget.transporte.nome,
                                  serviceId: widget.transporte.id, // Replace with the actual service ID
                                  serviceType: 'Transporte', // Replace with the actual service type
                                ),
                              ),
                            );
                          },
                          child: Text("Promover"),
                        ),

                      ],
                    ),

                    const SizedBox(height: 23.0),
                    Divider(
                      thickness: 1,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 23.0),

                    const Text(
                      'Descrição do Transporte:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(widget.transporte.descricao),
                    const SizedBox(height: 16.0),

                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       _showAgendamentoDialog(context);
                    //     },
                    //     child: const Text('Reservar'),
                    //   ),
                    // ),

                    const SizedBox(height: 16.0),
                    const SizedBox(height: 16.0),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Agendamentos:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Column(
                      children: _isLoading
                          ? [
                        // Pré-carregamento
                        for (int i = 0;
                        i < 5;
                        i++) // Adapte o número conforme necessário
                          _buildPlaceholderItem(),
                      ]
                          : agendamentos.map((agendamento) {
                        UsuarioModel usuario =
                        usuarios.firstWhere((user) => user.id == agendamento.quemID);

                        if (agendamento.tipoServico == "transporte") {
                          TodosTranspModel transporte =
                          buscarTransportePorId(agendamento.idServico);
                          return Container(
                            width: MediaQuery.of(context).size.width * .9,
                            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            // Construa o conteúdo com base no transporte
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(90),
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(25.0),
                                            child: CachedNetworkImage(
                                              imageUrl: usuario.foto,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Container(
                                              width: MediaQuery.of(context).size.width * .5,
                                              child: transporte.nome == "" ?
                                              Text("Agendamento Removido",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.red
                                                ),
                                                overflow: TextOverflow.ellipsis,

                                              )
                                                  : Text(usuario.nome,
                                                style: TextStyle(
                                                    fontSize: 16.0, fontWeight: FontWeight.w800),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              "Tel: ${usuario.telefone}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Email: ${usuario.email}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            Text(
                                              "Lugares: ${agendamento.lugares.toString()}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]
                                    ),
                                    // InkWell(
                                    //   onTap: () {
                                    //         _makePhoneCall(usuario.telefone); // Substitua com o número que você deseja chamar
                                    //       },
                                    //   child: transporte.id == ""
                                    //       ? Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 15, vertical: 8),
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.grey.withOpacity(.1),
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     child: Text("Não Disp."),
                                    //   )
                                    //       : Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 15, vertical: 8),
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.blue.withOpacity(.1),
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     child: Icon(Icons.phone, color: Colors.blue,),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        else if (agendamento.tipoServico == "Actividade") {
                          TodasActividadesModel atividade =
                          buscarActividadePorId(agendamento.idServico);
                          return Container(
                            width: MediaQuery.of(context).size.width * .9,
                            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // Construa o conteúdo com base no transporte
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(90),
                                            child: SizedBox.fromSize(
                                              size: const Size.fromRadius(25.0),
                                              child: CachedNetworkImage(
                                                imageUrl: usuario.foto,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Container(
                                                width: MediaQuery.of(context).size.width * .5,
                                                child: atividade.actividade == "" ?
                                                Text("Agendamento Removido",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.red
                                                  ),
                                                  overflow: TextOverflow.ellipsis,

                                                )
                                                    : Text(usuario.nome,
                                                  style: TextStyle(
                                                      fontSize: 16.0, fontWeight: FontWeight.w800),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                "Tel: ${usuario.telefone}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Email: ${usuario.email}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),

                                              Text(
                                                "Lugares: ${agendamento.lugares.toString()}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    ),
                                    // InkWell(
                                    //   onTap: () {
                                    //         _makePhoneCall(usuario.telefone); // Substitua com o número que você deseja chamar
                                    //       },
                                    //   child: transporte.id == ""
                                    //       ? Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 15, vertical: 8),
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.grey.withOpacity(.1),
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     child: Text("Não Disp."),
                                    //   )
                                    //       : Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 15, vertical: 8),
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.blue.withOpacity(.1),
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     child: Icon(Icons.phone, color: Colors.blue,),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        else if (agendamento.tipoServico == "acomodacao") {
                          PatrocinadosAcomModel acomodacao =
                          buscarAcomodacaoPorId(agendamento.idServico);
                          return  Container(
                            width: MediaQuery.of(context).size.width * .9,
                            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Construa o conteúdo com base no transporte
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(90),
                                            child: SizedBox.fromSize(
                                              size: const Size.fromRadius(25.0),
                                              child: CachedNetworkImage(
                                                imageUrl: usuario.foto,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Container(
                                                width: MediaQuery.of(context).size.width * .5,
                                                child: acomodacao.acom == "" ?
                                                Text("Agendamento Removido",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.red
                                                  ),
                                                  overflow: TextOverflow.ellipsis,

                                                )
                                                    : Text(usuario.nome,
                                                  style: TextStyle(
                                                      fontSize: 16.0, fontWeight: FontWeight.w800),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                "Tel: ${usuario.telefone}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Email: ${usuario.email}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),

                                              Text(
                                                "Lugares: ${agendamento.lugares.toString()}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    ),
                                    // InkWell(
                                    //   onTap: () {
                                    //         _makePhoneCall(usuario.telefone); // Substitua com o número que você deseja chamar
                                    //       },
                                    //   child: transporte.id == ""
                                    //       ? Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 15, vertical: 8),
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.grey.withOpacity(.1),
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     child: Text("Não Disp."),
                                    //   )
                                    //       : Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 15, vertical: 8),
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.blue.withOpacity(.1),
                                    //       borderRadius: BorderRadius.circular(10),
                                    //     ),
                                    //     child: Icon(Icons.phone, color: Colors.blue,),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(); // Retorne um container vazio para outros casos
                      }).toList(),
                    ),



                    const SizedBox(
                      height: 25,
                    ),
                    // Exibir comentários da acomodação
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: comentariosFiltrados.isNotEmpty ?
                      const Text("Avaliações de clientes",
                        style: TextStyle(fontSize:
                        25, fontWeight: FontWeight.bold),)
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


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


// Função para formatar a data
  String formatarData(DateTime data) {
    final dateFormat = DateFormat("d MMM y");
    return dateFormat.format(data);
  }

  Widget _buildPlaceholderItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  height: 105,
                  width: MediaQuery.of(context).size.width * .9,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16))),
            ),
          ],
        ),
      ),
    );
  }

  TodosTranspModel buscarTransportePorId(String id) {
    TodosTranspModel transporteEncontrado = todosTranspList.firstWhere(
          (transporte) => transporte.id == id,
      orElse: () => TodosTranspModel(
        id: '',
        servico: '',
        descricao: '',
        preco: '0',
        destino: '',
        nome: '',
        local: '',
        lugares: '',
        img: '',
        sponsor: false,
        boxColor: Color(0x00000000),
        conta: '',
        dataPartida: '',
      ),
    );

    return transporteEncontrado;
  }

  TodasActividadesModel buscarActividadePorId(String id) {
    TodasActividadesModel atividadeEncontrada = todasActividadesList.firstWhere(
          (atividade) => atividade.id == id,
      orElse: () => TodasActividadesModel(
        id: '',
        servico: '',
        descricao: '',
        preco: '0',
        actividade: '',
        conta: '',
        local: '',
        img: '',
        pais: '',
        estado: '',
        cidade: '',
        sponsor: false,
        boxColor: Color(0x00000000),
      ),
    );

    return atividadeEncontrada;
  }

  PatrocinadosAcomModel buscarAcomodacaoPorId(String id) {
    PatrocinadosAcomModel acomodacaoEncontrada =
    patrocinadosAcomList.firstWhere(
          (acomodacao) => acomodacao.id == id,
      orElse: () => PatrocinadosAcomModel(
        conta: '',
        descricao: '',
        servico: '',
        id: '',
        img: '',
        local: '',
        preco: '',
        pais: '',
        estado: '',
        cidade: '',
        avaliacao: '',
        acom: '',
        wifi: false,
        chuveiro: false,
        sinal: false,
        cama: false,
        boxColor: Color(0x00000000),
        sponsor: false,
      ),
    );

    return acomodacaoEncontrada;
  }
}
