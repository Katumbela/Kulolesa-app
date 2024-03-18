
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/models/meus_servicos_model/meus_servicos_model.dart';
import 'package:kulolesa/models/usuariosModel.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
import 'package:kulolesa/pages/perfil/paginas_meus_servicos/promover_servico.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/sponsored_models.dart';
import '../../../models/user_provider.dart';


class DetalhesMinhasAcomodacaoPage extends StatefulWidget {
  final TodasMinhasAcomModel acomodacao;
  final String heroTag;

  // final List<ReviewsAcomModel> comentarios;

  const DetalhesMinhasAcomodacaoPage({super.key, required this.acomodacao, required this.heroTag});

  @override
  State<DetalhesMinhasAcomodacaoPage> createState() => _DetalhesMinhasAcomodacaoPageState();
}

class _DetalhesMinhasAcomodacaoPageState extends State<DetalhesMinhasAcomodacaoPage> {

  String? _de ;
  String? _para ;


  String DataFormatada = "";
  DateTime tgl = DateTime.now();
  DateTime now = DateTime.now();

  final TextStyle valueStyle = const TextStyle(fontSize: 16.0);

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

      await FirebaseFirestore.instance.collection('acomodacoes').doc(widget.acomodacao.id).delete();

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



  Future<void> _selectDateDe() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _de = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

  bool _isReserving = false;

  DateTime? entryDate;
  DateTime? exitDate;
  List<UsuarioModel> usuarios = [];


  Future<void> fetchUsuarios() async {
    List<UsuarioModel> fetchedUsuarios = await UsuarioModel.getUsuarios();
    setState(() {
      usuarios = fetchedUsuarios;
    });
  }


  Future<void> _selectEntryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: entryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != entryDate) {
      setState(() {
        entryDate = picked;
      });
    }
  }



  Future<void> _selectExitDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: exitDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != exitDate) {
      setState(() {
        exitDate = picked;
      });
    }
  }


  List<ReviewsAcomModel> comentariosFiltrados = [];

  void pegarComments() async {
    // Obter a lista de comentários do Firestore
    List<ReviewsAcomModel> comentarios = await ReviewsAcomModel.getReviewAcom(widget.acomodacao.id);

    // Filtrar os comentários que correspondem à acomodação atual
    comentariosFiltrados = comentarios.toList();
  }


// Função para formatar a data
  String formatarData(DateTime data) {
    final dateFormat = DateFormat("d MMM y");
    return dateFormat.format(data);
  }

  List<MeusAgendamentos> agendamentos = [];
  bool _isLoading = true;

  void _getMeusAgendamentos() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    String yourUniqueID = userData!.uniqueID;
    List<MeusAgendamentos> meusAgendamentos =
    await MeusAgendamentos.getTodosMeusAgendamentos(widget.acomodacao.id);

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

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
    pegarComments();
    _getMeusAgendamentos();
    getDados();
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(titulo: widget.acomodacao.acom,),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: widget.heroTag,
                child: Container(
                  decoration: BoxDecoration(
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
                      imageUrl: widget.acomodacao.img,
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
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.1),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.4),
                      blurRadius: 40,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.acomodacao.wifi
                            ? const Icon(
                          Icons.wifi,
                          size: 25,
                          color: EstiloApp.secondaryColor,
                        )
                            : const Icon(
                          Icons.wifi_off,
                          size: 25,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        widget.acomodacao.cama
                            ? const Icon(
                          Icons.bed_outlined,
                          size: 25,
                          color: EstiloApp.secondaryColor,
                        )
                            : const Text(''),
                        const SizedBox(
                          width: 6,
                        ),
                        widget.acomodacao.chuveiro
                            ? const Icon(
                          Icons.shower_outlined,
                          size: 25,
                          color: EstiloApp.secondaryColor,
                        )
                            : const Text(''),
                        const SizedBox(
                          width: 6,
                        ),
                        widget.acomodacao.sinal
                            ? const Icon(
                          Icons.speaker_phone_rounded,
                          size: 25,
                          color: EstiloApp.secondaryColor,
                        )
                            : const Text(''),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 25, color: EstiloApp.tcolor,),
                        const SizedBox(width: 6,),
                        Text(widget.acomodacao.avaliacao, style: const TextStyle
                          (
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [

                        const Icon(Icons.location_on_outlined, size:25, color: Colors.blue,),
                        Text(widget.acomodacao.local, style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(

                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),

                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Preço", style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),),
                              Text(widget.acomodacao.preco, style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(.2),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Categoria", style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),),
                              Text(widget.acomodacao.servico, style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Pagamento", style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),),
                              Text("Em Espécie", style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   child: const Text("Escolha as datas a reservar", style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.black
                    //   ),),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    //
                    // Container(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //
                    //       Container(
                    //         margin: const EdgeInsets.only(top: 6),
                    //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    //         decoration: BoxDecoration(
                    //           color: Colors.grey[200],
                    //           borderRadius: BorderRadius.circular(16),
                    //         ),
                    //         child: InkWell(
                    //           onTap: () => _selectEntryDate(context),
                    //           child: entryDate != null
                    //               ? Text(
                    //             DateFormat.yMEd().format(entryDate!),
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //               color: Colors.grey[800],
                    //               fontSize: 15.0,
                    //             ),
                    //           )
                    //               : Text(
                    //             "Data de Entrada",
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //               color: Colors.grey[800],
                    //               fontSize: 15.0,
                    //               fontFamily: "",
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //
                    //       Container(
                    //         margin: const EdgeInsets.only(top: 6),
                    //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    //         decoration: BoxDecoration(
                    //           color: Colors.grey[200],
                    //           borderRadius: BorderRadius.circular(16),
                    //         ),
                    //         child: InkWell(
                    //           onTap: () => _selectExitDate(context),
                    //           child: exitDate != null
                    //               ? Text(
                    //             DateFormat.yMEd().format(exitDate!),
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //               color: Colors.grey[800],
                    //               fontSize: 15.0,
                    //               fontFamily: "",
                    //             ),
                    //           )
                    //               : Text(
                    //             "Data de Saída",
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //               color: Colors.grey[800],
                    //               fontSize: 15.0,
                    //               fontFamily: "",
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //
                    //       // ElevatedButton(
                    //       //   onPressed: _para == null ? null : _selectDatepara,
                    //       //   child: Text( _para!),
                    //       // )
                    //     ],
                    //   ),
                    // ),
                    //
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //
                    //
                    //     const Text(""),
                    //     ElevatedButton(
                    //       onPressed: _isReserving ? null : () async {
                    //         if (entryDate != null && exitDate != null) {
                    //           try {
                    //             setState(() {
                    //               _isReserving = true; // Define o estado de reserva como verdadeiro
                    //             });
                    //
                    //             // Resto do código para fazer a reserva
                    //
                    //             // await Future.delayed(Duration(seconds: 2)); // Simulação de uma operação demorada
                    //
                    //             final userProvider = Provider.of<UserProvider>(context, listen: false);
                    //             final userData = userProvider.user;
                    //
                    //
                    //             if (entryDate != null && exitDate != null) {
                    //               try {
                    //                 // Acessar o Firestore
                    //                 FirebaseFirestore firestore = FirebaseFirestore.instance;
                    //
                    //                 // Dados da reserva
                    //                 Map<String, dynamic> reservaData = {
                    //                   'espaco': widget.acomodacao.acom,
                    //                   'servico': "Acomodacao",
                    //                   'idServico': widget.acomodacao.id,
                    //                   'idUsuario': userData!.uniqueID,
                    //                   'dataEntrada': entryDate,
                    //                   'dataSaida': exitDate,
                    //                   'contaVendedor': widget.acomodacao.conta,
                    //                   'quando': DateTime.now(),
                    //                   // Adicione outros detalhes relevantes aqui
                    //                 };
                    //
                    //                 // Adicionar um novo documento na coleção "agendamentos"
                    //                 await firestore.collection('agendamentos').add(reservaData);
                    //                 await FirebaseFirestore.instance.collection('notificacoes').add({
                    //                   'para': widget.acomodacao.conta,
                    //                   'conteudo': "Fez uma reserva em ${widget.acomodacao.acom}, para  $entryDate até $exitDate, abra a app e entre em contacto com ${userData!.fullName}",
                    //                   'nome': userData!.fullName,
                    //                   'status': 'pendente',
                    //                   'lido': false,// Você pode adicionar mais campos conforme necessário
                    //                   'quando': FieldValue.serverTimestamp(), // Para registrar a data e hora do pedido
                    //                 });
                    //
                    //                 Navigator.push(
                    //                   context,
                    //                   PageTransition(
                    //                     type: PageTransitionType.fade,
                    //                     duration: const Duration(milliseconds: 250),
                    //                     child:  SucessoAG(titulo: "Seu agendamento"),
                    //                   ),
                    //                 );
                    //                 // Mostrar um aviso de sucesso
                    //                 // ScaffoldMessenger.of(context).showSnackBar(
                    //                 //   const SnackBar(
                    //                 //     content: Text('Reserva efetuada com sucesso!'),
                    //                 //   ),
                    //                 // );
                    //               } catch (e) {
                    //                 // Mostrar um aviso de erro, se ocorrer algum problema
                    //                 ScaffoldMessenger.of(context).showSnackBar(
                    //                   SnackBar(
                    //                     content: Text('Erro ao fazer a reserva: $e'),
                    //                     backgroundColor: Colors.red,
                    //                   ),
                    //                 );
                    //               }
                    //             } else {
                    //               // Mostrar um aviso se as datas de entrada e saída não forem selecionadas
                    //               ScaffoldMessenger.of(context).showSnackBar(
                    //                 const SnackBar(
                    //                   content: Text('Selecione as datas de entrada e saída.'),
                    //                   backgroundColor: Colors.red,
                    //                 ),
                    //               );
                    //             }
                    //
                    //
                    //
                    //             // Após a reserva bem-sucedida
                    //
                    //
                    //             Navigator.push(
                    //               context,
                    //               PageTransition(
                    //                 type:
                    //                 PageTransitionType.rightToLeft,
                    //                 duration:
                    //                 const Duration(milliseconds: 150),
                    //                 child: const SucessoAG(titulo: "Seu agendamento"),
                    //               ),
                    //             );
                    //
                    //             // ScaffoldMessenger.of(context).showSnackBar(
                    //             //   const SnackBar(
                    //             //     content: Text('Reserva efetuada com sucesso!'),
                    //             //   ),
                    //             // );
                    //           } catch (e) {
                    //             // Mostrar um aviso de erro
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(
                    //                 content: Text('Erro ao fazer a reserva: $e'),
                    //                 backgroundColor: Colors.red,
                    //               ),
                    //             );
                    //           } finally {
                    //             setState(() {
                    //               _isReserving = false; // Define o estado de reserva como falso
                    //             });
                    //           }
                    //         } else {
                    //           // Mostrar um aviso se as datas de entrada e saída não forem selecionadas
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             const SnackBar(
                    //               content: Text('Selecione as datas de entrada e saída.'),
                    //               backgroundColor: Colors.orange,
                    //             ),
                    //           );
                    //         }
                    //       },
                    //       child: _isReserving
                    //           ? SizedBox(
                    //           height: 30,
                    //           width:30,
                    //           child: CircularProgressIndicator()
                    //       ) // Mostra o CircularProgressIndicator se estiver reservando
                    //           : const Text("Reservar"),
                    //     )
                    //
                    //
                    //   ],
                    // ),

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
                                  nome: widget.acomodacao.acom,
                                  serviceId: widget.acomodacao.id, // Replace with the actual service ID
                                  serviceType: 'Acomodacao', // Replace with the actual service type
                                ),
                              ),
                            );
                          },
                          child: Text("Promover"),
                        ),

                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),

              agendamentos.length <= 0 ? Text("") : Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                child: Text("Agendamentos", textAlign: TextAlign.start, style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800
                ),
                ),
            ),
            SizedBox(
              height: 10,
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
                else if (agendamento.tipoServico == "acomodacao") {
                  PatrocinadosAcomModel acomodacao =
                  buscarAcomodacaoPorId(agendamento.idServico);
                  return  Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment,
                                        children: [
                                          Text(
                                            "Para: ${agendamento.quando.split("@")[1]}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          Text(
                                            "         Até: ${agendamento.quando.split("@")[2]}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
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
    );
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
