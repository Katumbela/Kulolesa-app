import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kulolesa/pages/PaginaExpe.dart';
import 'package:kulolesa/pages/PaginaTransp.dart';
import 'package:kulolesa/pages/acomPage.dart';
import 'package:kulolesa/pages/detalhesAcom.dart';
import 'package:kulolesa/pages/detalhestransp.dart';
import 'package:kulolesa/pages/notificacoes.dart';
import 'package:kulolesa/pages/perfil.dart';
import 'package:kulolesa/pages/perfil/escolher_post_servicos.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../models/provider.dart';
import '../models/servicos_model.dart';
import '../models/pesquisar.dart';
import '../models/sponsored_models.dart';
import '../models/user_provider.dart';
import '../widgets/saudacao.dart';
import 'login_page.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  List<ServicosModel> servicos = [];
  List<TodosTranspModel> patrocinadosTransp = [];
  List<PatrocinadosAcomModel> patrocinadosAcom = [];

  void _getServicos() {
    servicos = ServicosModel.getServices();
  }

  void _getSponsored() async {
    List<TodosTranspModel> allTransportes =
        await TodosTranspModel.getAllTransp();

    // Filtrar os transportes com sponsor igual a true
    patrocinadosTransp =
        allTransportes.where((transp) => transp.sponsor).toList();
  }

  bool _isLoading = true;

  void _getSponsoredAcom() async {
    patrocinadosAcom = await PatrocinadosAcomModel.getSponsoredAcom();
    setState(() {
      _isLoading = false;
    });
  }

  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;
  bool _showFilter = false;

  List<Resultado> _filteredResults = [];

  void _filterResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _showResults = false;
        _filteredResults.clear();
      });
      return;
    }

    List<Resultado> filtered = Dados.resultadosPesquisa
        .where((resultado) =>
            resultado.local.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _showResults = true;
      _filteredResults = filtered;
    });
  }

  void _logout(BuildContext context) async {
    // Limpar dados de autenticação ou qualquer outra coisa que você precise fazer durante o logout

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(UserData(
      fullName: '',
      email: '',
      phone: '',
      birthdate: '',
      accountType: '',
      uniqueID: '',
      profilePic: '',
      password: '',
    ));

    // Navegar de volta para a tela de login ou qualquer outra tela que você preferir
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _checkLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    if (!isLoggedIn || userData == null || userData.uniqueID.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }


  String criarSaudacao(String userName) {
    final saudacaoService = SaudacaoService();
    return saudacaoService.getMensagemSaudacao(userName);
  }


  void _showNotification(para, nome, conteudo, id) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "4432423",
      'kulolesa',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      234235243, // ID da notificação
      nome,
      conteudo,
      platformChannelSpecifics,
    );
  }


  void listenForAgendamentos() {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    FirebaseFirestore.instance.collection('notificacoes').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          final agendamentoData = change.doc.data() as Map<String, dynamic>;
          final para = agendamentoData['para'];
          final conteudo = agendamentoData['conteudo'];
          final quando = agendamentoData['quando'];
          final nome = agendamentoData['nome'];
          final id = change.doc.id;

          // Verifique se o campo "para" é igual ao userData!.uniqueID
          if (para == userData!.uniqueID) {
            // Exiba a notificação quando um novo agendamento for adicionado
            _showNotification(para, nome, conteudo, id );
          }
        }
      });
    });

  }


  int _unreadNotificationsCount = 0;

  @override
  void initState() {
    super.initState();
    _checkLogin(context);
    _getServicos();
    _getSponsored();
    _getSponsoredAcom();
    listenForAgendamentos();
    _getUnreadNotificationsCount();

    FlutterAppBadger.updateBadgeCount(_unreadNotificationsCount);

    Provider.of<UserProvider>(context, listen: false).initialize();

  }


  Future<void> _getUnreadNotificationsCount() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    if (userData != null) {
      try {
        final QuerySnapshot notificationsSnapshot = await FirebaseFirestore.instance
            .collection('notificacoes')
            .where('para', isEqualTo: userData.uniqueID)
            .where('lido', isEqualTo: false)
            .get();

        setState(() {
          _unreadNotificationsCount = notificationsSnapshot.size;
        });
      } catch (e) {
        print('Erro ao carregar notificações não lidas: $e');
      }
    }
  }

  Future<void> _markAllNotificationsAsRead() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    if (userData != null) {
      try {
        final QuerySnapshot notificationsSnapshot = await FirebaseFirestore.instance
            .collection('notificacoes')
            .where('para', isEqualTo: userData.uniqueID)
            .where('lido', isEqualTo: false)
            .get();

        for (final doc in notificationsSnapshot.docs) {
          await doc.reference.update({'lido': true});
        }

        setState(() {
          _unreadNotificationsCount = 0;
        });
      } catch (e) {
        print('Erro ao marcar notificações como lidas: $e');
      }
    }
  }



  List<Widget> _buildPageIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < _anuncios.length; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i ? Colors.blue : Colors.grey,
          ),
        ),
      );
    }
    return indicators;
  }


   Container _header() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                    "assets/logo.png",
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  "Kulolesa",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: EstiloApp.ccolor,
                  ),
                )
              ],
            ),

            Container(
              child: Row(
                children: [
                  userData!.accountType
                      != "Usuario" ?
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          duration: const Duration(milliseconds: 200),
                          child: const Outros(),
                        ),
                      );
                    },

                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/house.png"),
                    ),
                  )
                      : Text(""),

                  const SizedBox(
                    width: 10,
                  ),

                  SizedBox(
                    height: 30,
                    width: 30,
                    child: InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.leftToRight,
                            duration: const Duration(milliseconds: 200),
                            child: const Notifications(),
                          ),
                        );
                        await _markAllNotificationsAsRead();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset("assets/bell.png"),
                          if (_unreadNotificationsCount > 0)
                            Positioned(
                              top: -6,
                              right: -.2,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Text(
                                  _unreadNotificationsCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: EstiloApp.ccolor, width: 3.0)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 250),
                            child:  Perfil(),
                          ),
                        );
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
                                width:
                                15, // Tamanho do CircularProgressIndicator
                                height:
                                15, // Tamanho do CircularProgressIndicator
                                child: CircularProgressIndicator(
                                  color: EstiloApp.ccolor,
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
            ),
          ],
        ),
      ),
    );
  }

  Column _acomPatrocinada() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: _isLoading
                ? [
              // Pré-carregamento
              for (int i = 0;
              i < 4;
              i++) // Adapte o número conforme necessário
                _buildPlaceholderItem(),
            ]
                : List.generate(
              patrocinadosAcom.length,
                  (index) {
                final acomodacao = patrocinadosAcom[index];
                final heroTag =
                    'acomodacao_$index'; // Tag única para o Hero

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesAcomodacaoPage(
                          acomodacao: acomodacao,
                          heroTag: heroTag,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 125.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff1D1617).withOpacity(.07),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .3,
                          height: MediaQuery.of(context).size.height * .2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Hero(
                            tag: heroTag,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(70.0),
                                child: CachedNetworkImage(
                                  imageUrl: acomodacao.img,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 6, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    .54,
                                child: Text(
                                  acomodacao.acom,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: EstiloApp.ccolor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: EstiloApp.ccolor,
                                    size: 18,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        .47,
                                    child:
                                    Text(
                                      acomodacao.pais+", "+ acomodacao.estado,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  acomodacao.wifi
                                      ? const Icon(
                                    Icons.wifi,
                                    size: 15,
                                    color: EstiloApp.secondaryColor,
                                  )
                                      : const Icon(
                                    Icons.wifi_off,
                                    size: 15,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  acomodacao.cama
                                      ? const Icon(
                                    Icons.bed_outlined,
                                    size: 15,
                                    color: EstiloApp.secondaryColor,
                                  )
                                      : const Text(''),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  acomodacao.chuveiro
                                      ? const Icon(
                                    Icons.shower_outlined,
                                    size: 15,
                                    color: EstiloApp.secondaryColor,
                                  )
                                      : const Text(''),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  acomodacao.sinal
                                      ? const Icon(
                                    Icons.speaker_phone_rounded,
                                    size: 18,
                                    color: EstiloApp.secondaryColor,
                                  )
                                      : const Text(''),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    .55,
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.star_border_purple500,
                                            color: EstiloApp.tcolor,
                                            size: 24),
                                        Text(
                                          acomodacao.avaliacao,
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Text(
                                          "AOA",
                                          style: TextStyle(
                                              fontSize: 8,
                                              fontWeight:
                                              FontWeight.w500),
                                        ),
                                        Text(
                                          acomodacao.preco,
                                          style: const TextStyle(
                                            fontSize: 18.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _quadroAnuncio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Conteúdo dos anúncios
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: PageView.builder(
            itemCount: _anuncios.length,
            controller: PageController(
              initialPage: _currentPage,
            ),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _anuncios[index];
            },
          ),
        ),
        // Indicadores dos anúncios
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicators(),
        ),
      ],
    );
  }

  Column _transPatrocinado(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(
          height: 15,
        ),
        Container(
          height: MediaQuery.of(context).size.height * .25,
          color: Colors.white70,
          child: ListView.separated(
            itemCount: patrocinadosTransp.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 30.0),
            itemBuilder: (context, index) {
              final heroTagg = "transppppp_$index";
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
                  tag: patrocinadosTransp[index].img + "-patrocin_transp",
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      color: patrocinadosTransp[index].boxColor.withOpacity(.3),
                      borderRadius: BorderRadius.circular(08),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(
                                  MediaQuery.of(context).size.height * .55),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: patrocinadosTransp[index].img,
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width * .55,
                        //     decoration: BoxDecoration(
                        //       color: EstiloApp.secondaryColor.withOpacity(.65),
                        //       borderRadius: const BorderRadius.only(
                        //         bottomLeft: Radius.circular(15),
                        //         bottomRight: Radius.circular(15),
                        //       ),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 8, horizontal: 5),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Container(
                        //             width: MediaQuery.of(context).size.width * .54,
                        //             child: Text(
                        //               patrocinadosTransp[index].nome,
                        //               style: const TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 18,
                        //                 color: Colors.white,
                        //               ),
                        //               overflow: TextOverflow.ellipsis,
                        //             ),
                        //           ),
                        //           Row(
                        //             crossAxisAlignment: CrossAxisAlignment.end,
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
                        //                         Icons.location_on_outlined,
                        //                         color: Colors.white,
                        //                         size: 16.0,
                        //                       ),
                        //                       Text(
                        //                         patrocinadosTransp[index].local,
                        //                         style: const TextStyle(
                        //                           color: Colors.white,
                        //                           fontSize: 12,
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   const SizedBox(height: 1.0),
                        //                   Row(
                        //                     children: [
                        //                       const Icon(
                        //                         Icons.arrow_downward_rounded,
                        //                         color: Colors.white,
                        //                         size: 16.0,
                        //                       ),
                        //                       Text(
                        //                         patrocinadosTransp[index]
                        //                             .destino,
                        //                         style: const TextStyle(
                        //                             color: Colors.white,
                        //                             fontSize: 12.0),
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
                        //                     patrocinadosTransp[index].preco,
                        //                     style: const TextStyle(
                        //                       color: Colors.white,
                        //                       fontSize: 25.0,
                        //                       fontWeight: FontWeight.bold,
                        //                     ),
                        //                   ),
                        //                   const Text(
                        //                     "Kz",
                        //                     style: TextStyle(
                        //                       fontSize: 12.0,
                        //                       fontWeight: FontWeight.w400,
                        //                       color: Colors.white,
                        //                     ),
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
      ],
    );
  }

  Column _servisosLista() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            "Explore a kulolesa.",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 22,
                fontFamily: "roboto"),
          ),
        ),
        const SizedBox(
          height: 15,
        ),

        // Lista de serviços
        Container(
          height: 130,
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: ListView.separated(
            itemCount: servicos.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 30.0),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navegue para a página correspondente ao serviço clicado
                  if (servicos[index].servico == "Acomodação") {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        duration: const Duration(milliseconds: 200),
                        child: const PaginaAcomodacao(),
                      ),
                    );
                  } else if (servicos[index].servico == "Transportes") {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 200),
                        child:  PaginaTransportes(),
                      ),
                    );
                  } else if (servicos[index].servico == "Experiências") {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        duration: const Duration(milliseconds: 200),
                        child: const PaginaExpe(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 130,
                  decoration: BoxDecoration(
                      color: servicos[index].boxColor.withOpacity(.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: EstiloApp.primaryColor.withOpacity(.2),
                          width: 1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(servicos[index].icon),
                        ),
                      ),
                      Text(
                        servicos[index].servico,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Container _barraPesquisa() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 5, right: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff1D1617).withOpacity(0.11),
                  blurRadius: 40,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _filterResults,
                  decoration: InputDecoration(
                    filled: true,
                    focusColor: Colors.black54,
                    fillColor: Colors.white,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.search, size: 30.0, color: Colors.grey),
                    ),
                    suffixIcon: SizedBox(
                      width: 100,
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const VerticalDivider(
                              color: Color(0xFF59a9ff),
                              indent: 10,
                              endIndent: 10,
                              thickness: 0.1,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _showFilter = !_showFilter;
                                  _searchController.clear();
                                  _filteredResults.clear();
                                  _showResults = false;
                                });
                              },
                              icon: Icon(
                                _showFilter ? Icons.close : Icons.close,
                                size: 30.0,
                                color: EstiloApp.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Pesquisar",
                    hintStyle:
                    TextStyle(color: Colors.grey[400], fontSize: 14.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (_showResults)
                  SizedBox(
                    height:
                    300, // Defina uma altura adequada para os resultados
                    child: ListView.builder(
                      itemCount: _filteredResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_filteredResults[index].local),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_filteredResults[index].foto),
                              Text(_filteredResults[index].preco),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
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

  PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<Widget> _anuncios = [
    _transPatrocinado(context),
    _acomPatrocinada(),
    // Adicione mais itens de acordo com suas necessidades.
  ];


  Future<void> _handleRefresh() async {
    // Aguarde um período simulado para dar a sensação de atualização (você pode remover isso)
    await Future.delayed(Duration(seconds: 3));

    // Use o setState para reconstruir a árvore de widgets
    setState(() {
      // Coloque aqui a lógica de atualização se necessário
      _getServicos();
      _getSponsored();
      _getSponsoredAcom();
      _getUnreadNotificationsCount();
    });
  }



  @override
  Widget build(BuildContext context) {
    _getServicos();
    _getSponsored();
    _getSponsoredAcom();
    _getUnreadNotificationsCount();


    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;


    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _header(),
              // _barraPesquisa(),
              Container(
                margin: EdgeInsets.only(bottom: 10,top: 10, left: 20, right: 20),
                padding: const EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(criarSaudacao(userData!.fullName)+"", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                   ),
                ),
              ),

              _servisosLista(),

              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              _transPatrocinado(context),
              const SizedBox(
                height: 45,
              ),
              _acomPatrocinada()
            ],
          ),
        ),
      ),
    );
  }

}
