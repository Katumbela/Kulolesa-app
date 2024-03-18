import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kulolesa/detalhesActividades.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kulolesa/models/pesquisar.dart';
import 'package:kulolesa/pages/PaginaExpe.dart';
import 'package:kulolesa/pages/PaginaTransp.dart';
import 'package:kulolesa/pages/acomPage.dart';
import 'package:kulolesa/pages/chooseSearchType.dart';
import 'package:kulolesa/pages/detalhesAcom.dart';
import 'package:kulolesa/pages/detalhestransp.dart';
import 'package:kulolesa/pages/notificacoes.dart';
import 'package:kulolesa/pages/perfil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kulolesa/pages/perfil/agendamentos.dart';
import 'package:kulolesa/pages/perfil/escolher_post_servicos.dart';
import 'package:kulolesa/pages/searchActivities.dart';
import 'package:kulolesa/pages/searchCars.dart';
import 'package:kulolesa/pages/searchHosts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../models/provider.dart';
import '../models/servicos_model.dart';
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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<ServicosModel> servicos = [];
  List<TodosTranspModel> patrocinadosTransp = [];
  List<PatrocinadosAcomModel> patrocinadosAcom = [];

  List<PatrocinadosAcomModel> sponsoredAcom = [];

  List<TodasActividadesModel> patrocinadosActividades = [];
  List<TodasActividadesModel> TodasActividades = [];
  List<TodosTranspModel> TodosTransportes = [];
  List<TodosTranspModel> todosTranspOriginal =
      []; // Mantenha uma cópia dos dados originais

  void _getSponsoredT() async {
    List<TodosTranspModel> allTransportes =
        await TodosTranspModel.getAllTransp();

    // Filtrar os transportes com sponsor igual a true
    patrocinadosTransp =
        allTransportes.where((transp) => transp.sponsor).toList();
  }

  void _getAllTransp() async {
    todosTranspOriginal =
        await TodosTranspModel.getAllTransp(); // Preencha a lista original
    TodosTransportes =
        todosTranspOriginal; // Inicialize a lista de resultados com os dados originais
    setState(() {
      _isLoading = false;
    });
  }

  void _getAllActivities() async {
    TodasActividades = await TodasActividadesModel.getAllActivities();
    setState(() {
      _isLoading = false;
    });
  }

  void _getSponsoredActivities() async {
    List<TodasActividadesModel> allActivities =
        await TodasActividadesModel.getAllActivities();

    // Filtrar os transportes com sponsor igual a true
    patrocinadosActividades =
        allActivities.where((transp) => transp.sponsor).toList();
  }

  void _getSponsoredAcom() async {
    patrocinadosAcom = await PatrocinadosAcomModel.getSponsoredAcom();
    setState(() {
      _isLoading = false;
    });
  }

  void _getSponsoredA() async {
    List<PatrocinadosAcomModel> allSponsorAcom =
        await PatrocinadosAcomModel.getSponsoredAcom();

    // Filtrar os transportes com sponsor igual a true
    sponsoredAcom =
        allSponsorAcom.where((acomodacao) => acomodacao.sponsor).toList();
  }

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
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      "4432423",
      'kulolesa',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

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

    FirebaseFirestore.instance
        .collection('notificacoes')
        .snapshots()
        .listen((snapshot) {
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
            _showNotification(para, nome, conteudo, id);
          }
        }
      });
    });
  }

  int _unreadNotificationsCount = 0;

  late String textoSearch;
  late String textoTab;

  late Future<List<DocumentSnapshot<Map<String, dynamic>>>> _future;

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> _getPromocoes() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('promocoes')
        .where('status', isEqualTo: true)
        .get();

    return snapshot.docs;
  }

  @override
  void initState() {
    super.initState();
    _future = _getPromocoes();
    _checkLogin(context);
    _getServicos();
    _getSponsored();
    _getSponsoredT();
    _getAllTransp();
    _getSponsoredActivities();
    _getSponsoredA();
    _getSponsoredAcom();
    listenForAgendamentos();
    _getUnreadNotificationsCount();

    textoSearch = "Transportes";
    textoTab = "Transportes";

    FlutterAppBadger.updateBadgeCount(_unreadNotificationsCount);

    Provider.of<UserProvider>(context, listen: false).initialize();
  }

  Future<void> _getUnreadNotificationsCount() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    if (userData != null) {
      try {
        final QuerySnapshot notificationsSnapshot = await FirebaseFirestore
            .instance
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
        final QuerySnapshot notificationsSnapshot = await FirebaseFirestore
            .instance
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
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: Image.asset(
                    "assets/Ku.png",
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              switch (textoSearch) {
                                case "Acomodações":
                                  return PesquisarAcomodacao();
                                case "Atividades":
                                  return PesquisarActividades();
                                case "Transportes":
                                  return PesquisarTransporte();
                                default:
                                  return ChooseTypeSearch();
                              }
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 2),
                        width: MediaQuery.of(context).size.width * .7,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(70),
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Encontre ${textoSearch}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              Container(
                                  // padding:  EdgeInsets.only(left: 15, right: 5),
                                  width: 40,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.search,
                                        size: 22, color: Colors.blueAccent),
                                  )),
                            ]),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: textoSearch == "Transportes"
                                    ? Colors.blue[100]
                                    : Colors.orange[100]?.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    textoSearch = "Transportes";
                                  });
                                },
                                child: Image.asset(
                                  'assets/car1.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            Text("Transportes",
                                style: TextStyle(
                                    fontSize: 8, color: Colors.blueAccent)),
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .125),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: textoSearch == "Acomodações"
                                    ? Colors.blue[100]
                                    : Colors.orange[100]?.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    textoSearch = "Acomodações";
                                  });
                                },
                                child: Image.asset(
                                  'assets/bed1.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            Text("Acomodações",
                                style: TextStyle(
                                    fontSize: 8, color: Colors.blueAccent)),
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .125),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: textoSearch == "Atividades"
                                    ? Colors.blue[100]
                                    : Colors.orange[100]?.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    textoSearch = "Atividades";
                                  });
                                },
                                child: Image.asset(
                                  'assets/hoq1.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            Text("Transportes",
                                style: TextStyle(
                                    fontSize: 8, color: Colors.blueAccent)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
                ? ([
                    // Pré-carregamento
                    for (int i = 0;
                        i < 4;
                        i++) // Adapte o número conforme necessário
                      _buildPlaceholderItem(),
                  ])
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
                                width: MediaQuery.of(context).size.width * .2,
                                height:
                                    MediaQuery.of(context).size.height * .11,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Hero(
                                  tag: heroTag,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(30.0),
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
                                    // SizedBox(height: 10),
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
                                          child: Text(
                                            acomodacao.pais +
                                                ", " +
                                                acomodacao.estado,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .65,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                acomodacao.wifi
                                                    ? const Icon(
                                                        Icons.wifi,
                                                        size: 15,
                                                        color: EstiloApp
                                                            .secondaryColor,
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
                                                        color: EstiloApp
                                                            .secondaryColor,
                                                      )
                                                    : const Text(''),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                acomodacao.chuveiro
                                                    ? const Icon(
                                                        Icons.shower_outlined,
                                                        size: 15,
                                                        color: EstiloApp
                                                            .secondaryColor,
                                                      )
                                                    : const Text(''),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                acomodacao.sinal
                                                    ? const Icon(
                                                        Icons
                                                            .speaker_phone_rounded,
                                                        size: 18,
                                                        color: EstiloApp
                                                            .secondaryColor,
                                                      )
                                                    : const Text(''),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "AOA",
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  acomodacao.preco,
                                                  style: const TextStyle(
                                                    fontSize: 15.5,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // SizedBox(
                                    //   width: MediaQuery.of(context).size.width *
                                    //       .55,
                                    //   child: Row(
                                    //     children: [
                                    //       Row(
                                    //         children: [
                                    //           const Icon(
                                    //               Icons.star_border_purple500,
                                    //               color: EstiloApp.tcolor,
                                    //               size: 24),
                                    //           Text(
                                    //             acomodacao.avaliacao,
                                    //             style: const TextStyle(
                                    //                 fontSize: 18.0,
                                    //                 fontWeight: FontWeight.bold,
                                    //                 color: Colors.black),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       const Spacer(),
                                    //       Row(
                                    //         children: [
                                    //           const Text(
                                    //             "AOA",
                                    //             style: TextStyle(
                                    //                 fontSize: 8,
                                    //                 fontWeight:
                                    //                     FontWeight.w500),
                                    //           ),
                                    //           Text(
                                    //             acomodacao.preco,
                                    //             style: const TextStyle(
                                    //               fontSize: 18.5,
                                    //               fontWeight: FontWeight.w600,
                                    //               color: Colors.black,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       )
                                    //     ],
                                    //   ),
                                    // )
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

/*
  Column _servisosLista() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20),
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
                        child: PaginaTransportes(),
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
*/
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

  Column _activitiesBuilder() {
    return Column(
      children: _isLoading
          ? [
              // Pré-carregamento
              for (int i = 0; i < 5; i++) // Adapte o número conforme necessário
                _buildPlaceholderItem(),
            ]
          : List.generate(TodasActividades.length, (index) {
              final heroTagg = 'act_$index'; // Tag única para o Hero

              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalheActividades(
                            actividade: TodasActividades[index],
                            heroTag: heroTagg,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: "act_" + TodasActividades[index].img,
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 0, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .9,
                              height: MediaQuery.of(context).size.height * .2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.blue.withOpacity(.3),
                                      width: 1)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: TodasActividades[index].img,
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
                            Container(
                              height: MediaQuery.of(context).size.height * .1,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.04),
                                // border: Border.all(color: Colors.blue.withOpacity(.3), width: 1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .85,
                                      child: Text(
                                        TodasActividades[index].actividade,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.grey[600],
                                              size: 20.0,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              TodasActividades[index].local,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              TodasActividades[index].preco,
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Kz ",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[700],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              );
            }),
    );
  }

  Column _transportesBuilder() {
    return Column(
      children: _isLoading
          ? [
              // Pré-carregamento
              for (int i = 0; i < 5; i++) // Adapte o número conforme necessário
                _buildPlaceholderItem(),
            ]
          : List.generate(TodosTransportes.length, (index) {
              final heroTagg = 'traanssppp_$index'; // Tag única para o Hero

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
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.height * .14,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.white, width: 1)),
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
                                    MediaQuery.of(context).size.height * .15,
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
                                            MainAxisAlignment.spaceBetween,
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
                                                    Icons.people_alt_outlined,
                                                    color: Colors.grey[600],
                                                    size: 14.0,
                                                  ),
                                                  const SizedBox(width: 4.0),
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
                                                    Icons.location_on_outlined,
                                                    color: Colors.grey[600],
                                                    size: 14.0,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    TodosTransportes[index]
                                                        .local,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_downward_rounded,
                                                    color: Colors.grey[600],
                                                    size: 18.0,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .25,
                                                    child: Text(
                                                      TodosTransportes[index]
                                                          .destino,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        // fontSize: 15,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                TodosTransportes[index].preco,
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                "Kz",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey[700],
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
    _getSponsoredA();
    _getAllTransp();
    _getSponsoredT();
    _getSponsoredActivities();
    _getSponsoredA();

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
              SizedBox(height: 6),

              Container(
                child: FutureBuilder(
                  future: _future,
                  builder: (context,
                      AsyncSnapshot<
                              List<DocumentSnapshot<Map<String, dynamic>>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    }

                    final List<DocumentSnapshot<Map<String, dynamic>>>
                        documents = snapshot.data!;
                    List<Widget> slides = [];

                    for (var document in documents) {
                      slides.add(
                        Container(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                  imageUrl: document['linkImagem'],
                                  height: 180),
                            ],
                          ),
                        ),
                      );
                    }

                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 230.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                      items: slides,
                    );
                  },
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          textoTab = "Transportes";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: textoTab == "Transportes"
                              ? Colors.white
                              : Colors.blueAccent,
                          border: textoTab == "Transportes"
                              ? Border.all(color: Colors.blueAccent)
                              : null,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text("Transportes",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textoTab == "Transportes"
                                  ? Colors.blueAccent
                                  : Colors.white,
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          textoTab = "Acomodações";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: textoTab == "Acomodações"
                              ? Colors.white
                              : Colors.blueAccent,
                          border: textoTab == "Acomodações"
                              ? Border.all(color: Colors.blueAccent)
                              : null,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text("Acomodações",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textoTab == "Acomodações"
                                  ? Colors.blueAccent
                                  : Colors.white,
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          textoTab = "Experiências";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: textoTab == "Experiências"
                              ? Colors.white
                              : Colors.blueAccent,
                          border: textoTab == "Experiências"
                              ? Border.all(color: Colors.blueAccent)
                              : null,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text("Experiências",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textoTab == "Experiências"
                                  ? Colors.blueAccent
                                  : Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),

              // _transPatrocinado(context),
              const SizedBox(
                height: 20,
              ),
              textoTab == "Acomodações"
                  ? _acomPatrocinada()
                  : (textoTab == "Experiências"
                      ? _activitiesBuilder()
                      : (textoTab == "Transportes"
                          ? _transportesBuilder()
                          : Container())),
            ],
          ),
        ),
      ),
    );
  }

  Column _acomPatrocinadaHead() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    String storageBaseUrl =
        'https://firebasestorage.googleapis.com/v0/b/kulolesaapp.appspot.com/o/';
    String imagePath =
        'perfil%2F${userData!.profilePic}?alt=media&token=0240187d-8b96-48e5-80de-f41a16d527fd';

    String imageUrlProfile = userData!.profilePic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                "Bem-vindo(a) ${userData!.fullName.split(" ")[0]}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 5),
              child: Container(
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
                      child: Image.network(
                        imageUrlProfile,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height *
              .25, // Defina a altura desejada para a lista horizontal
          child: _isLoading
              ? _buildPlaceholderItem()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sponsoredAcom.length,
                  itemBuilder: (context, index) {
                    final acomodacao = sponsoredAcom[index];
                    final heroTag =
                        'acomodacaoHead_$index'; // Tag única para o Hero

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
                        width: MediaQuery.of(context).size.width *
                            .95, // Defina a largura desejada para cada item
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: const Color(0xff1D1617).withOpacity(.07),
                          //     blurRadius: 40,
                          //     offset: const Offset(0, 10),
                          //     spreadRadius: 0,
                          //   ),
                          // ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .9,
                              height: MediaQuery.of(context).size.height * .3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Hero(
                                tag: heroTag,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(100.0),
                                    child: CachedNetworkImage(
                                      imageUrl: acomodacao.img,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       top: 8.0, bottom: 3, left: 10),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Container(
                            //         width: MediaQuery.of(context).size.width *
                            //             .45,
                            //         child: Text(
                            //           acomodacao.acom,
                            //           style: const TextStyle(
                            //             fontSize: 18.0,
                            //             fontWeight: FontWeight.bold,
                            //             color: EstiloApp.ccolor,
                            //           ),
                            //           overflow: TextOverflow.ellipsis,
                            //           maxLines: 1,
                            //         ),
                            //       ),
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         children: [
                            //           const Icon(
                            //             Icons.location_on_outlined,
                            //             color: EstiloApp.ccolor,
                            //             size: 13,
                            //           ),
                            //           Container(
                            //
                            //               width: MediaQuery.of(context).size.width *
                            //                   .3,
                            //               child: Text(acomodacao.local, overflow: TextOverflow.ellipsis,)
                            //           ),
                            //         ],
                            //       ),
                            //       const SizedBox(
                            //         height: 0,
                            //       ),
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           acomodacao.wifi
                            //               ? const Icon(
                            //             Icons.wifi,
                            //             size: 13,
                            //             color: EstiloApp.secondaryColor,
                            //           )
                            //               : const Icon(
                            //             Icons.wifi_off,
                            //             size: 13,
                            //             color: Colors.red,
                            //           ),
                            //           const SizedBox(
                            //             width: 6,
                            //           ),
                            //           acomodacao.cama
                            //               ? const Icon(
                            //             Icons.bed_outlined,
                            //             size: 13,
                            //             color: EstiloApp.secondaryColor,
                            //           )
                            //               : const Text(''),
                            //           const SizedBox(
                            //             width: 6,
                            //           ),
                            //           acomodacao.chuveiro
                            //               ? const Icon(
                            //             Icons.shower_outlined,
                            //             size: 15,
                            //             color: EstiloApp.secondaryColor,
                            //           )
                            //               : const SizedBox(),
                            //           const SizedBox(
                            //             width: 6,
                            //           ),
                            //           acomodacao.sinal
                            //               ? const Icon(
                            //             Icons.speaker_phone_rounded,
                            //             size: 15,
                            //             color: EstiloApp.secondaryColor,
                            //           )
                            //               : const SizedBox(),
                            //         ],
                            //       ),
                            //       SizedBox(
                            //         width: MediaQuery.of(context).size.width * .42,
                            //         child: Row(
                            //           children: [
                            //             Row(
                            //               children: [
                            //                 const Icon(Icons.star_border_purple500,
                            //                     color: EstiloApp.tcolor, size: 15),
                            //                 Text(
                            //                   acomodacao.avaliacao,
                            //                   style: const TextStyle(
                            //                       fontSize: 14.0,
                            //                       fontWeight: FontWeight.bold,
                            //                       color: Colors.black),
                            //                 ),
                            //               ],
                            //             ),
                            //
                            //             const Spacer(),
                            //
                            //             Row(
                            //               children: [
                            //                 const Text(
                            //                   "AOA",
                            //                   style: TextStyle(
                            //                       fontSize: 8,
                            //                       fontWeight: FontWeight.w500),
                            //                 ),
                            //                 const SizedBox(
                            //                   width: 2,
                            //                 ),
                            //                 Text(
                            //                   acomodacao.preco,
                            //                   style: const TextStyle(
                            //                     fontSize: 15.5,
                            //                     fontWeight: FontWeight.w600,
                            //                     color: Colors.black,
                            //                   ),
                            //                 ),
                            //               ],
                            //             )
                            //           ],
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // )
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
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Inicio(),
    Pagamento(),
    Notifications(),
    Perfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 10,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
