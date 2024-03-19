import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/models/usuariosModel.dart';
import 'package:kulolesa/pages/alertas/sucesso.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:page_transition/page_transition.dart';
import '../models/sponsored_models.dart';
import 'package:provider/provider.dart';
import '../models/provider.dart';
import '../models/user_provider.dart';

class DetalhesAcomodacaoPage extends StatefulWidget {
  final PatrocinadosAcomModel acomodacao;
  final String heroTag;
  // final List<ReviewsAcomModel> comentarios;

  const DetalhesAcomodacaoPage(
      {super.key, required this.acomodacao, required this.heroTag});

  @override
  State<DetalhesAcomodacaoPage> createState() => _DetalhesAcomodacaoPageState();
}

class _DetalhesAcomodacaoPageState extends State<DetalhesAcomodacaoPage> {
  String? _de;
  String? _para;

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
        if (tgl.isBefore(now)) {
          // timerSnackbar(
          //   context: context,
          //   backgroundColor: Colors.red[500],
          //   contentText: "Escolha uma data a partir de hoje",
          //   // buttonPrefixWidget: Icon(Icons.error_outline, color: Colors.red[100]),
          //   buttonLabel: "",
          //   afterTimeExecute: () => print('acionado'),
          //   second: 8,
          // );
        } else {
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
  List<ReviewsAcomModel> comentariosFiltrados = [];

  Future<void> fetchUsuarios() async {
    List<UsuarioModel> fetchedUsuarios = await UsuarioModel.getUsuarios();
    setState(() {
      usuarios = fetchedUsuarios;
    });
  }

  void pegarComments() async {
    // Obter a lista de comentários do Firestore
    List<ReviewsAcomModel> comentarios =
        await ReviewsAcomModel.getReviewAcom(widget.acomodacao.id);

    // Filtrar os comentários que correspondem à acomodação atual
    comentariosFiltrados = comentarios.toList();
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
      initialDate: entryDate ?? DateTime.now(),
      firstDate: entryDate ?? DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != exitDate) {
      setState(() {
        exitDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
    pegarComments();
  }

// Função para formatar a data
  String formatarData(DateTime data) {
    final dateFormat = DateFormat("d MMM y");
    return dateFormat.format(data);
  }

  bool _isFilled = false;

  void _toggleHeart() {
    setState(() {
      _isFilled = !_isFilled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 400.0,
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
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                          child: Container(
                            width: 40, // Defina o tamanho desejado
                            height: 40, // Defina o tamanho desejado
                            child: CachedNetworkImage(
                              imageUrl: widget.acomodacao.img,
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
                  Positioned(
                    top: 60,
                    left: 10,
                    child: GestureDetector(
                      onTap: _toggleHeart,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.5),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: _isFilled
                            ? Icon(
                                Icons.favorite,
                                size: 25,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.favorite_border,
                                size: 25,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
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
                              // const Icon(
                              //   Icons.location_on_outlined,
                              //   size: 25,
                              //   color: Colors.blue,
                              // ),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .85,
                                    child: Text(
                                      widget.acomodacao.pais +
                                          ", " +
                                          widget.acomodacao.estado +
                                          ", " +
                                          widget.acomodacao.cidade,
                                      style: const TextStyle(
                                        // overflow: TextOverflow.ellipsis,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    const Icon(
                                      Icons.star,
                                      size: 25,
                                      color: EstiloApp.tcolor,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      widget.acomodacao.avaliacao,
                                      style: const TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Categoria",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      widget.acomodacao.servico,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Pagamento",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      "Em Espécie",
                                      style: TextStyle(
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
                          Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Escolha as datas a reservar",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    onTap: () => _selectEntryDate(context),
                                    child: entryDate != null
                                        ? Text(
                                            DateFormat.yMEd()
                                                .format(entryDate!),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 15.0,
                                            ),
                                          )
                                        : Text(
                                            "Data de Entrada",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14.0,
                                            ),
                                          ),
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    onTap: () => _selectExitDate(context),
                                    child: exitDate != null
                                        ? Text(
                                            DateFormat.yMEd().format(exitDate!),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 15.0,
                                            ),
                                          )
                                        : Text(
                                            "Data de Saída",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14.0,
                                              fontFamily: "",
                                            ),
                                          ),
                                  ),
                                ),

                                // ElevatedButton(
                                //   onPressed: _para == null ? null : _selectDatepara,
                                //   child: Text( _para!),
                                // )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Exibir comentários da acomodação
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: comentariosFiltrados.isNotEmpty
                          ? const Text(
                              "Avaliações de clientes",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          : const Text(""),
                    ),
                    Column(
                      children: comentariosFiltrados.map((comentario) {
                        UsuarioModel usuario = usuarios
                            .firstWhere((user) => user.id == comentario.quemId);

                        return Container(
                          width: MediaQuery.of(context).size.width * 10,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          child: Text(
                                            usuario.nome,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          comentario.rating.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        color: Colors.black,
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
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "" + widget.acomodacao.preco,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 115,
                height: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  onPressed: _isReserving
                      ? null
                      : () async {
                          if (entryDate != null && exitDate != null) {
                            try {
                              setState(() {
                                _isReserving =
                                    true; // Define o estado de reserva como verdadeiro
                              });

                              // Resto do código para fazer a reserva

                              // await Future.delayed(Duration(seconds: 2)); // Simulação de uma operação demorada

                              final userProvider = Provider.of<UserProvider>(
                                  context,
                                  listen: false);
                              final userData = userProvider.user;

                              if (entryDate != null && exitDate != null) {
                                try {
                                  // Acessar o Firestore
                                  FirebaseFirestore firestore =
                                      FirebaseFirestore.instance;

                                  // Dados da reserva

                                  Map<String, dynamic> reservaData = {
                                    'espaco': widget.acomodacao.acom,
                                    'servico': "acomodacao",
                                    'idServico': widget.acomodacao.id,
                                    'idUsuario': userData!.uniqueID,
                                    'dataEntrada': formatarData(entryDate!),
                                    'dataSaida': formatarData(exitDate!),
                                    'contaVendedor': widget.acomodacao.conta,
                                    'quando': DateTime.now(),
                                    // Adicione outros detalhes relevantes aqui
                                  };

                                  // Adicionar um novo documento na coleção "agendamentos"
                                  await firestore
                                      .collection('agendamentos')
                                      .add(reservaData);

                                  await FirebaseFirestore.instance
                                      .collection('notificacoes')
                                      .add({
                                    'para': widget.acomodacao.conta,
                                    'conteudo':
                                        "${userData!.fullName.split(" ")[0]} fez uma reserva em ${widget.acomodacao.acom}, para  ${formatarData(entryDate!)} até ${formatarData(exitDate!)}, abra a app e entre em contacto com ${userData!.fullName}",
                                    'nome': userData!.fullName,
                                    'status': 'pendente',
                                    'foto': userData!.profilePic,
                                    'lido':
                                        false, // Você pode adicionar mais campos conforme necessário
                                    'quando': FieldValue
                                        .serverTimestamp(), // Para registrar a data e hora do pedido
                                  });

                                  await FirebaseFirestore.instance
                                      .collection('notificacoes')
                                      .add({
                                    'para': userData!.uniqueID,
                                    'conteudo':
                                        "Olá ${userData!.fullName.split(" ")[0]} acabou de fazer uma reserva em ${widget.acomodacao.acom}, para  ${formatarData(entryDate!)} até ${formatarData(exitDate!)}, em breve será contactado.",
                                    'nome': "Kulolesa - Agendamentos",
                                    'status': 'pendente',
                                    'foto': userData!.profilePic,
                                    'lido':
                                        false, // Você pode adicionar mais campos conforme necessário
                                    'quando': FieldValue
                                        .serverTimestamp(), // Para registrar a data e hora do pedido
                                  });

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: SucessoAG(titulo: "Sua reserva"),
                                    ),
                                  );
                                  // Mostrar um aviso de sucesso
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text('Reserva efetuada com sucesso!'),
                                  //   ),
                                  // );
                                } catch (e) {
                                  // Mostrar um aviso de erro, se ocorrer algum problema
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Erro ao fazer a reserva: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                // Mostrar um aviso se as datas de entrada e saída não forem selecionadas
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Selecione as datas de entrada e saída.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }

                              // Após a reserva bem-sucedida

                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 150),
                                  child: const SucessoAG(
                                      titulo: "Seu agendamento"),
                                ),
                              );

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text('Reserva efetuada com sucesso!'),
                              //   ),
                              // );
                            } catch (e) {
                              // Mostrar um aviso de erro
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro ao fazer a reserva: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              setState(() {
                                _isReserving =
                                    false; // Define o estado de reserva como falso
                              });
                            }
                          } else {
                            // Mostrar um aviso se as datas de entrada e saída não forem selecionadas
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Selecione as datas de entrada e saída.'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                  child: _isReserving
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child:
                              CircularProgressIndicator()) // Mostra o CircularProgressIndicator se estiver reservando
                      : Text(
                          "Reservar",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
