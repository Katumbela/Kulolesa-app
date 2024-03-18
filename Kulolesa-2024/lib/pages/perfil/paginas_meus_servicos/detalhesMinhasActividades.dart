import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/models/sponsored_models.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
import 'package:kulolesa/pages/perfil/paginas_meus_servicos/promover_servico.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/meus_servicos_model/meus_servicos_model.dart';
import '../../../models/user_provider.dart';
import '../../../models/usuariosModel.dart';



class DetalheMinhasActividades extends StatefulWidget {
  final TodasMinhasActividadesModel actividade;
  final String heroTag;

  const DetalheMinhasActividades({super.key,required this.heroTag, required this.actividade});

  @override
  State<DetalheMinhasActividades> createState() => _DetalheMinhasActividadesState();
}

class _DetalheMinhasActividadesState extends State<DetalheMinhasActividades> {



  DateTime? dataReserva;


  Future<void> _selectReservaDate(BuildContext context) async {
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


  List<MeusAgendamentos> agendamentos = [];
  bool _isLoading = true;

  void _getMeusAgendamentos() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    String yourUniqueID = userData!.uniqueID;
    List<MeusAgendamentos> meusAgendamentos =
    await MeusAgendamentos.getTodosMeusAgendamentos(widget.actividade.id);

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
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () => _selectReservaDate(context),
                  child: dataReserva != null
                      ? Text(
                    DateFormat.yMEd().format(dataReserva!),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 15.0,
                    ),
                  )
                      : Text(
                    "Data de Entrada",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 15.0,
                    ),
                  ),
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

      await FirebaseFirestore.instance.collection('atividades').doc(widget.actividade.id).delete();

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
        'conteudo': "Fez uma reserva em ${widget.actividade.actividade}, para  $dataPartida para $numeroDeLugares, abra a app e entre em contacto com ${userData!.fullName}",
        'nome': userData!.fullName,
        'status': 'pendente',
        'lido': false,// Você pode adicionar mais campos conforme necessário
        'quando': FieldValue.serverTimestamp(), // Para registrar a data e hora do pedido
      });


      // Fechar o diálogo de carregamento e exibir o diálogo de sucesso
      Navigator.push(
        context,
        PageTransition(
          type:
          PageTransitionType.rightToLeft,
          duration:
          const Duration(milliseconds: 200),
          child:  SucessoAG(titulo: "Sua reserva para ${widget.actividade.actividade}"),
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
    List<ReviewsAcomModel> comentarios = await ReviewsAcomModel.getReviewAcom(widget.actividade.id);

    // Filtrar os comentários que correspondem à acomodação atual
    comentariosFiltrados = comentarios.toList();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDados();
    getDados();
    pegarComments();
    fetchUsuarios();
    _getMeusAgendamentos();
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
                      tag: "act_"+widget.heroTag, // Tag deve ser a mesma usada no ListTile anterior
                      child: Container(
                        width: MediaQuery.of(context).size.width * .1,
                        height: MediaQuery.of(context).size.height * .8,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.actividade.img,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
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
                    widget.actividade.sponsor == true ? Container(
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
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                            children: [
                              Text("Pagamento", style: TextStyle(
                                fontWeight: FontWeight.w400,

                              )),
                              Spacer(),
                              Text("Em espécie", style: TextStyle(
                                fontWeight: FontWeight.w900,

                              )),
                            ]
                        )
                    ),
                    const SizedBox(height: 16.0),

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
                                  nome: widget.actividade.actividade,
                                  serviceId: widget.actividade.id, // Replace with the actual service ID
                                  serviceType: 'Actividade', // Replace with the actual service type
                                ),
                              ),
                            );
                          },
                          child: Text("Promover"),
                        ),

                      ],
                    ),
                    const SizedBox(height: 23.0),

                    agendamentos.length <= 0 ? Text("") : Text("Agendamentos", style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800
                    )),

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
                              color: Colors.green.withOpacity(.4),
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
                                                child: transporte.nome == "" ?
                                                Text(usuario.nome,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.blue
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
                                                child: atividade.actividade == "" ?
                                                Text(usuario.nome,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.blue,
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
                                                "${usuario.email}",
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
                                                Text(usuario.nome,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.blue
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
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: comentariosFiltrados.isNotEmpty ?
                      const Text("Reviews de clientes",
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
