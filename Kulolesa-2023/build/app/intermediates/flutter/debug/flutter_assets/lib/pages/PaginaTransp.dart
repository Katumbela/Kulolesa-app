import 'package:cached_network_image/cached_network_image.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/pages/detalheTodosTransportes.dart';
import 'package:kulolesa/pages/detalhestransp.dart';
import 'package:kulolesa/pages/perfil.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import '../models/sponsored_models.dart';
import '../models/user_provider.dart';
import '../widgets/saudacao.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';


class PaginaTransportes extends StatefulWidget {


  @override
  State<PaginaTransportes> createState() => _PaginaTransportesState();
}

class _PaginaTransportesState extends State<PaginaTransportes> {
  List<TodosTranspModel> patrocinadosTransp = [];
  List<TodosTranspModel> TodosTransportes = [];


  void _getSponsoredT() async {
    List<TodosTranspModel> allTransportes =
        await TodosTranspModel.getAllTransp();

    // Filtrar os transportes com sponsor igual a true
    patrocinadosTransp =
        allTransportes.where((transp) => transp.sponsor).toList();
  }

  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;
  bool _showFilter = false;
  String selectedFilter = 'Todos';
  List<TodosTranspModel> _filteredResults = [];

  bool _isLoading = true;

  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();
  final controller = TextEditingController();

  bool Nenhum = false;
  TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<TodosTranspModel> todosTranspOriginal = []; // Mantenha uma cópia dos dados originais

  void _getAllTransp() async {
    todosTranspOriginal = await TodosTranspModel.getAllTransp(); // Preencha a lista original
    TodosTransportes = todosTranspOriginal; // Inicialize a lista de resultados com os dados originais
    setState(() {
      _isLoading = false;
    });
  }

  void _filterResults() {
    final startLocation = _startSearchFieldController.text.toLowerCase();
    final endLocation = _endSearchFieldController.text.toLowerCase();
    final selectedDate = _dateController.text ?? "/"; // Obtenha a data selecionada

    // Aplicar filtros aos resultados
    List<TodosTranspModel> filteredResults = todosTranspOriginal.where((transp) {
      final transpStartLocation = transp.local.toLowerCase();
      final transpEndLocation = transp.destino.toLowerCase();
      final transpDate = transp.dataPartida; // Substitua com o campo de data apropriado

      // Verifique se o ponto de partida e o ponto de chegada contêm os termos de pesquisa
      // e a data é a mesma que a selecionada (ou qualquer outra lógica de data que você precise).
      return transpStartLocation.contains(startLocation) &&
          transpEndLocation.contains(endLocation) && transpDate.contains(selectedDate);
    }).toList();

    setState(() {
      TodosTransportes = filteredResults; // Atualize a lista de resultados
    });

    if(TodosTransportes.isEmpty) {
      Nenhum = true;
    }
    else {
      Nenhum = false;
    }
    print(TodosTransportes);
  }

  String criarSaudacao(String userName) {
    final saudacaoService = SaudacaoService();
    return saudacaoService.getMensagemSaudacao(userName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllTransp();
  }


  Future<void> _handleRefresh() async {
    // Aguarde um período simulado para dar a sensação de atualização (você pode remover isso)
    await Future.delayed(Duration(seconds: 2));

    // Use o setState para reconstruir a árvore de widgets
    setState(() {
      // Coloque aqui a lógica de atualização se necessário
      _getAllTransp();
      _getSponsoredT();
    });
  }


  @override
  Widget build(BuildContext context) {

    _getSponsoredT();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    return Scaffold(
      appBar: CustomAppBar(titulo: "Encontre Transportes"),
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Função para executar quando o usuário atualizar
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // scrollDirection: Axis.vertical,
          children: [
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    criarSaudacao(userData!.fullName),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: EstiloApp.secondaryColor, width: 3.0)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Perfil()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(100.0),
                        child: CachedNetworkImage(
                          imageUrl: userData!.profilePic,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                              width: 15, // Tamanho do CircularProgressIndicator
                              height:
                              15, // Tamanho do CircularProgressIndicator
                              child: CircularProgressIndicator(
                                color: Colors.blue,
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
              ],
            ),
            const SizedBox(
              height: 0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .75,
              padding: const EdgeInsets.all(8.0),
              child: _barraPesquisa(),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Transportes em destaque",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              height: MediaQuery.of(context).size.height * .25,
              child: _isLoading
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Pré-carregamento
                          for (int i = 0;
                              i < 5;
                              i++) // Adapte o número conforme necessário
                            _buildPlaceholderItemHead(),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: patrocinadosTransp.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 30.0),
                      itemBuilder: (context, index) {
                        final heroTagg = "traspppttt_$index";
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalhesTransportePage(
                                  transporte: patrocinadosTransp[index],
                                  heroTag: heroTagg,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: patrocinadosTransp[index].img,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .4,
                              decoration: BoxDecoration(
                                color: patrocinadosTransp[index]
                                    .boxColor
                                    .withOpacity(.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height * .4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(
                                            MediaQuery.of(context).size.height *
                                                .4),
                                        child: CachedNetworkImage(
                                          imageUrl: patrocinadosTransp[index].img,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                            child: SizedBox(
                                              width:
                                                  30, // Tamanho do CircularProgressIndicator
                                              height:
                                                  30, // Tamanho do CircularProgressIndicator
                                              child: CircularProgressIndicator(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   bottom: 0,
                                  //   child: Container(
                                  //     width:
                                  //         MediaQuery.of(context).size.width * .4,
                                  //     decoration: BoxDecoration(
                                  //       color: EstiloApp.secondaryColor
                                  //           .withOpacity(.65),
                                  //       borderRadius: const BorderRadius.only(
                                  //         bottomLeft: Radius.circular(15),
                                  //         bottomRight: Radius.circular(15),
                                  //       ),
                                  //     ),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical: 8, horizontal: 5),
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Text(
                                  //             patrocinadosTransp[index].nome,
                                  //             style: const TextStyle(
                                  //               fontWeight: FontWeight.bold,
                                  //               fontSize: 15,
                                  //               color: Colors.white,
                                  //             ),
                                  //             overflow: TextOverflow.ellipsis,
                                  //           ),
                                  //           Row(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.end,
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.spaceBetween,
                                  //             children: [
                                  //               Column(
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Row(
                                  //                     children: [
                                  //                       const Icon(
                                  //                         Icons
                                  //                             .location_on_outlined,
                                  //                         color: Colors.white,
                                  //                         size: 15.0,
                                  //                       ),
                                  //                       Text(
                                  //                         patrocinadosTransp[
                                  //                                 index]
                                  //                             .local,
                                  //                         style: const TextStyle(
                                  //                           color: Colors.white,
                                  //                           fontSize: 10,
                                  //                         ),
                                  //                         overflow: TextOverflow
                                  //                             .ellipsis,
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   const SizedBox(height: 1.0),
                                  //                   Row(
                                  //                     children: <Widget>[
                                  //                       const Icon(
                                  //                         Icons
                                  //                             .arrow_downward_rounded,
                                  //                         color: Colors.white,
                                  //                         size: 16.0,
                                  //                       ),
                                  //                       Text(
                                  //                         patrocinadosTransp[
                                  //                                 index]
                                  //                             .destino,
                                  //                         style: const TextStyle(
                                  //                           color: Colors.white,
                                  //                           fontSize: 10.0,
                                  //                         ),
                                  //                         overflow: TextOverflow
                                  //                             .ellipsis,
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Row(
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.end,
                                  //                 children: [
                                  //                   Text(
                                  //                     patrocinadosTransp[index]
                                  //                         .preco,
                                  //                     style: const TextStyle(
                                  //                       color: Colors.white,
                                  //                       // fontSize: 18.0,
                                  //                       fontWeight:
                                  //                           FontWeight.bold,
                                  //                     ),
                                  //                     overflow:
                                  //                         TextOverflow.ellipsis,
                                  //                   ),
                                  //                   const Text(
                                  //                     "Kz",
                                  //                     style: TextStyle(
                                  //                       fontSize: 10.0,
                                  //                       fontWeight:
                                  //                           FontWeight.w400,
                                  //                       color: Colors.white,
                                  //                     ),
                                  //                     overflow:
                                  //                         TextOverflow.ellipsis,
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(
              height: 30,
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
                  : List.generate(TodosTransportes.length, (index) {
                      final heroTagg =
                          'traanssppp_$index'; // Tag única para o Hero

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalhesTransportePage(
                                    transporte: TodosTransportes[index],
                                    heroTag: heroTagg,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: TodosTransportes[index].img,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 0, top: 10, left: 20, right: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * .3,
                                      height: MediaQuery.of(context).size.height *
                                          .14,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.white,
                                              width: 1)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: TodosTransportes[index].img,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          placeholder: (context, url) => Center(
                                            child: SizedBox(
                                              width:
                                                  30, // Tamanho do CircularProgressIndicator
                                              height:
                                                  30, // Tamanho do CircularProgressIndicator
                                              child: CircularProgressIndicator(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .15,
                                        // decoration: BoxDecoration(
                                        //   color: Colors.grey.withOpacity(.05),
                                        //   border: Border.all(color: Colors.blue.withOpacity(.3), width: 1),
                                        //   borderRadius: BorderRadius.circular(16),
                                        // ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                TodosTransportes[index].nome,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .people_alt_outlined,
                                                            color:
                                                                Colors.grey[600],
                                                            size: 14.0,
                                                          ),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Text(
                                                            ' ${TodosTransportes[index].lugares} lugares ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 2.0),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            color:
                                                                Colors.grey[600],
                                                            size: 14.0,
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            TodosTransportes[
                                                                    index]
                                                                .local,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .arrow_downward_rounded,
                                                            color:
                                                                Colors.grey[600],
                                                            size: 18.0,
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * .25,
                                                            child: Text(
                                                              TodosTransportes[
                                                                      index]
                                                                  .destino,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[600],
                                                                // fontSize: 15,
                                                              ),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 1),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        TodosTransportes[index]
                                                            .preco,
                                                        style: TextStyle(
                                                          color: Colors.grey[700],
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                      Text(
                                                        "Kz",
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey[700],
                                                        ),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      );
                    }),
            ),
            SizedBox(
              height: 40.0,
            ),

            Nenhum && TodosTransportes.length <= 0 ? Container(
              padding: EdgeInsets.only(bottom: 70, top: 5, left: 35, right: 35),
              alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset("assets/notfound2.json", height: 140, width: 140),
                          Text("Não foi encontrado nenhum transporte com este trajeto", textAlign: TextAlign.center, style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.w700,
                          )),
                        ],
                      ),

            )
             : SizedBox.shrink(),

          ],
        ),
      ),
    );
  }

  Row _barraPesquisa() {
    return  Row(
            children: [

              // Campo de Ponto de Partida

              Expanded(
                child: SizedBox(
                  height: 40,
                  // padding: EdgeInsets.only(left: 0.0, right: 0.0), // Define o padding apenas à esquerda
                  child: TextField(
                    controller: _startSearchFieldController,
                    decoration: InputDecoration(
                      labelText: 'Partida',
                      contentPadding: EdgeInsets.only(top: 5, left: 10),
                      // hintStyle: TextStyle(fontSize: 12),
                      prefixIcon: Icon(Icons.location_on, size: 20, color: Colors.blueAccent),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 30, // Largura mínima do ícone
                        minHeight: 15, // Altura mínima do ícone
                      ),
                      // Remova a borda do lado direito
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                        borderSide: BorderSide.none, // Remove a borda
                      ),
                      // Adicione uma borda personalizada ao lado esquerdo
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Campo de Ponto de Chegada
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _endSearchFieldController,
                    decoration: InputDecoration(
                      labelText: 'Chegada',
                      contentPadding: EdgeInsets.only(top: 5, left: 10),
                      prefixIcon: Icon(Icons.location_on, size: 20, color: Colors.blueAccent),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 10, // Largura mínima do ícone
                        minHeight: 15, // Altura mínima do ícone
                      ),
                      // Remova a borda do lado direito
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                        borderSide: BorderSide.none, // Remove a borda
                      ),
                      // Adicione uma borda personalizada ao lado esquerdo
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Campo de Data

              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    readOnly: true, // Torna o campo de texto somente leitura para evitar entrada direta
                    controller: _dateController,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025, 12, 31),
                        // locale: Locale('pt'), // Set the locale to Portuguese
                      );

                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                          _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Data',
                      prefixIcon: Icon(Icons.calendar_today, size: 15, color: Colors.blueAccent),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 30, // Largura mínima do ícone
                        minHeight: 15, // Altura mínima do ícone
                      ),

                      contentPadding: EdgeInsets.only(top: 11),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                        borderSide: BorderSide.none, // Remove a borda
                      ),
                      // Adicione uma borda personalizada ao lado esquerdo
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Botão de Filtrar/Buscar
               InkWell(
                  onTap: () {
                    _filterResults(); // Implemente esta função para aplicar os filtros
                  },
                  child: SizedBox(
                    height: 40,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )
                      ),
                        child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
            ],
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
            Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(16))),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                  height: 100,
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

  Widget _buildPlaceholderItemHead() {
    return Container(
      margin: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
            width: MediaQuery.of(context).size.width * .38,
            height: MediaQuery.of(context).size.height * .4,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(16))),
      ),
    );
  }
}
