import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/models/meus_agendamentos.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/sponsored_models.dart';
import '../../models/user_provider.dart';
import '../../widgets/app_bar.dart';
import 'avaliar_servico.dart';

class Pagamento extends StatefulWidget {
  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  List<Agendamento> agendamentos = [];
  bool _isLoading = true;

  void _getMeusAgendamentos() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    String yourUniqueID = userData!.uniqueID;
    List<Agendamento> meusAgendamentos =
        await Agendamento.getMeusAgendamentos(yourUniqueID);

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


  Future<void> _handleRefresh() async {
    // Aguarde um período simulado para dar a sensação de atualização (você pode remover isso)
    await Future.delayed(Duration(seconds: 3));

    // Use o setState para reconstruir a árvore de widgets
    setState(() {
      // Coloque aqui a lógica de atualização se necessário
      _getMeusAgendamentos();
      getDados();
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getMeusAgendamentos();

    getDados();
  }

  @override
  Widget build(BuildContext context) {
    _getMeusAgendamentos();

    getDados();

    return Scaffold(
      appBar: CustomAppBar(titulo: "Minhas Reservas"),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          children: _isLoading
              ? [
                  // Pré-carregamento
                  for (int i = 0;
                      i < 5;
                      i++) // Adapte o número conforme necessário
                    _buildPlaceholderItem(),
                ]
              : agendamentos.map((agendamento) {
                  if (agendamento.tipoServico == "transporte") {
                    TodosTranspModel transporte =
                        buscarTransportePorId(agendamento.idServico);
                    return Container(
                      width: MediaQuery.of(context).size.width * .9,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Construa o conteúdo com base no transporte
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .8,
                            child: transporte.nome == "" ?
                            Text("Serviço Removido",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                color: Colors.red
                              ),
                              overflow: TextOverflow.ellipsis,

                            )
                            : Text(transporte.nome,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w800),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Preço: ${transporte.preco} kz",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Para: ${agendamento.quando.split("@")[0]}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "P. Partida: ${transporte.local == "" ? "--------" : transporte.local}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Destino: ${transporte.destino == "" ? "--------" : transporte.destino}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: transporte.id == ""
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            duration:
                                                const Duration(milliseconds: 300),
                                            child: Review(
                                              nome: transporte.nome,
                                              idServico: transporte.id,
                                              tipoServico: "transporte",
                                            ),
                                          ),
                                        );
                                      },
                                child: transporte.id == ""
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text("Não Disp."),
                                      )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text("Avaliar"),
                                      ),
                              ),
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
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Construa o conteúdo com base na atividade
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          atividade.actividade == "" ? Text(
                            "Serviço Indisponível",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800, color: Colors.red),
                          ) : Text(
                            atividade.actividade,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ) ,
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Preço: ${atividade.preco} kz",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Para: ${agendamento.quando.split("@")[0]}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: atividade.id == "" ? null : () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: const Duration(milliseconds: 300),
                                      child: Review(
                                        nome: atividade.actividade,
                                        idServico: atividade.id,
                                        tipoServico: "actividade",
                                      ),
                                    ),
                                  );
                                },

                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 8,
                                    ),
                                  decoration: BoxDecoration(
                                    color: atividade.id == "" ? Colors.grey.withOpacity(.1) : Colors.blue.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text("Avaliar"),
                                ),

                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  else if (agendamento.tipoServico == "acomodacao") {
                    PatrocinadosAcomModel acomodacao =
                        buscarAcomodacaoPorId(agendamento.idServico);
                    return Container(
                      width: MediaQuery.of(context).size.width * .9,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Construa o conteúdo com base na atividade
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          acomodacao.acom == "" ? Text(
                            "Serviço Indisponível",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800, color: Colors.red),
                          ) : Text(
                            acomodacao.acom,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ) ,
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Preço: ${acomodacao.preco} kz",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width: MediaQuery.of(context).size.width * .6,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Para: ${agendamento.quando.split("@")[1]}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Até: ${agendamento.quando.split("@")[2]}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: acomodacao.id == "" ? null : () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: const Duration(milliseconds: 300),
                                      child: Review(
                                        nome: acomodacao.acom,
                                        idServico: acomodacao.id,
                                        tipoServico: "acomodacao",
                                      ),
                                    ),
                                  );
                                },

                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: acomodacao.id == "" ? Colors.grey.withOpacity(.1) : Colors.blue.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text("Avaliar"),
                                ),

                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(); // Retorne um container vazio para outros casos
                }).toList(),
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
