import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kulolesa/estilos/estilo.dart';
// import 'package:kulolesa/pages/detalheActividades.dart';
// import 'package:kulolesa/pages/detalhestransp.dart';
import 'package:kulolesa/pages/perfil.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../detalhesActividades.dart';
import '../models/sponsored_models.dart';
import '../models/user_provider.dart';
import '../widgets/saudacao.dart';

class PaginaExpe extends StatefulWidget {
  const PaginaExpe({super.key});

  @override
  State<PaginaExpe> createState() => _PaginaExpeState();
}

class _PaginaExpeState extends State<PaginaExpe> {

  List<TodasActividadesModel> patrocinadosActividades = [];
  List<TodasActividadesModel> TodasActividades = [];


  void _getAllTransp() async {
    TodasActividades = await TodasActividadesModel.getAllActivities();
    setState(() {
      _isLoading = false;
    });
  }

  void _getSponsoredT() async {
    List<TodasActividadesModel> allActivities = await TodasActividadesModel.getAllActivities();

    // Filtrar os transportes com sponsor igual a true
    patrocinadosActividades = allActivities.where((transp) => transp.sponsor).toList();
  }


  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;
  bool _showFilter = false;
  String selectedFilter = 'Todos';
  List<TodasActividadesModel> _filteredResults = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAllTransp();
  }



  void _filterResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        _showResults = false;
        _filteredResults.clear();
      });
      return;
    }

    // Obtenha todos os transportes antes de filtrá-los
    List<TodasActividadesModel> allTransportes = await TodasActividadesModel.getAllActivities();

    List<TodasActividadesModel> filtered = allTransportes
        .where((transp) => transp.actividade.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _showResults = true;
      _filteredResults = filtered;
    });
  }

  String criarSaudacao(String userName) {
    final saudacaoService = SaudacaoService();
    return saudacaoService.getMensagemSaudacao(userName);
  }

  @override
  Widget build(BuildContext context) {
    _getAllTransp();
    _getSponsoredT();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    String storageBaseUrl =
        'https://firebasestorage.googleapis.com/v0/b/kulolesaapp.appspot.com/o/';
    String imagePath =
        'perfil%2F${userData!.profilePic}?alt=media&token=0240187d-8b96-48e5-80de-f41a16d527fd';

    String imageUrlProfile = userData!.profilePic;

    return Scaffold(
      appBar: CustomAppBar(titulo: "Encontre Experiências"),
      body: ListView(
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
                child:  Text(criarSaudacao(userData.fullName), style: TextStyle(
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
                        imageUrl: imageUrlProfile,
                        fit: BoxFit.cover,
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
          _barraPesquisa(),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Experiências em destaque", style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: MediaQuery.of(context).size.height * .25,

            child: _isLoading ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row( children:  [
              // Pré-carregamento
              for (int i = 0; i <4; i++) // Adapte o número conforme necessário
                _buildPlaceholderItemHead(),
            ],
            ),
            ) : ListView.separated(
              itemCount: patrocinadosActividades.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, right: 20),
              separatorBuilder: (context, index) => const SizedBox(width: 30.0),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalheActividades(
                          actividade: patrocinadosActividades[index], heroTag: "actividade"+patrocinadosActividades[index].img,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: "actividade"+patrocinadosActividades[index].img,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .4,
                      decoration: BoxDecoration(
                        color: patrocinadosActividades[index].boxColor.withOpacity(.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * .4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(
                                    MediaQuery.of(context).size.height * .4),
                                child: CachedNetworkImage(
                                  imageUrl: patrocinadosActividades[index].img,
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
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .4,
                              decoration: BoxDecoration(
                                color: EstiloApp.ccolor.withOpacity(.55),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patrocinadosActividades[index].actividade,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on_outlined,
                                                  color: Colors.white,
                                                  size: 13.0,
                                                ),
                                                Text(
                                                  patrocinadosActividades[index].local,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 1.0),

                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              patrocinadosActividades[index].preco,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Text(
                                              "Kz",
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
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
                );
              },
            ),

          ),

          const SizedBox(
            height: 30,
          ),




          Column(
            children:   _isLoading ? [
              // Pré-carregamento
              for (int i = 0; i < 5; i++) // Adapte o número conforme necessário
                _buildPlaceholderItem(),
            ]
                :  List.generate(
                TodasActividades.length, (index) {
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
                      tag: "act_"+TodasActividades[index].img,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                               Container(
                                  width: MediaQuery.of(context).size.width * .9,
                                  height: MediaQuery.of(context).size.height * .45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.blue.withOpacity(.3), width: 1)),
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
                                    height: MediaQuery.of(context).size.height * .12,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.04),
                                      // border: Border.all(color: Colors.blue.withOpacity(.3), width: 1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width *.85,
                                            child:
                                            Text(
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
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.end,
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
            }

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
        child:
        Container(
            width: MediaQuery.of(context).size.width * .85,
            height: MediaQuery.of(context).size.height * .55,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(16)
            )
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
        child:
        Container(
            width: MediaQuery.of(context).size.width * .38,
            height: MediaQuery.of(context).size.height * .4,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(16)
            )
        ),
      ),
    );
  }


  Container _barraPesquisa() {
    return Container(
      margin: const EdgeInsets.only(top: 2, left: 20, right: 20, bottom: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.0091),
            blurRadius: 50,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child:Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 5, right:5),
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
                      child:
                      Icon(Icons.search, size: 30.0, color: Colors.grey),
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
                                _showFilter
                                    ? Icons.close
                                    : Icons.close,
                                size: 30.0,
                                color: EstiloApp.ccolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Pesquisar Experiências",
                    hintStyle:
                    TextStyle(color: Colors.grey[400], fontSize: 14.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if(_filteredResults.length <= 0 && _showResults)
                    SizedBox(
                    // height: ,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Lottie.asset("assets/notfound2.json", width: 130, height: 100),
                        ),
                        Text("Lamentamos, não encontramos nenhuma actividade similar a esta! ", textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 12.0,
                        )),
                      ],
                    ),
                  ),
                if (_showResults)
                    SizedBox(
                    height: 350, // Defina uma altura adequada para os resultados
                    child: ListView.builder(
                      itemCount: _filteredResults.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalheActividades(
                                  actividade: _filteredResults[index],
                                  heroTag: 'imagemblwerra-${_filteredResults[index].img}', // Passe a tag do Hero aqui
                                ),
                              ),
                            );
                          },
                          child:  Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'imagembla-${_filteredResults[index].img}', // Use a mesma tag para o Hero
                                  child: CachedNetworkImage(
                                    imageUrl: _filteredResults[index].img, // Caminho da imagem
                                    fit: BoxFit.cover,
                                    width: 70, // Defina a largura desejada para a imagem
                                    height: 70, // Defina a altura desejada para a imagem
                                    placeholder: (context, url) => Center(
                                      child: SizedBox(
                                        width:
                                        12, // Tamanho do CircularProgressIndicator
                                        height:
                                        12, // Tamanho do CircularProgressIndicator
                                        child: CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(width: 8,),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(""),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: MediaQuery.of(context).size.width * .25,
                                          child: Text(_filteredResults[index].actividade, style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600
                                          ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("Local: ", style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300
                                        )),
                                        const SizedBox(width: 5),
                                        Text(_filteredResults[index].local, style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600
                                        ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("", style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300
                                        )),
                                        Text(_filteredResults[index].servico, style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400
                                        ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(_filteredResults[index].preco, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[800]), ),
                                      Text(" Kz", style: TextStyle(fontSize: 12, color: Colors.blue[800]), ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          // ListTile(
                          //   title: Text('Destino: ${_filteredResults[index].destino}'),
                          //   subtitle: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Hero(
                          //         tag: 'imagembla-${_filteredResults[index].img}', // Use a mesma tag para o Hero
                          //         child: Image.asset(
                          //           _filteredResults[index].img, // Caminho da imagem
                          //           fit: BoxFit.cover,
                          //           width: 50, // Defina a largura desejada para a imagem
                          //           height: 50, // Defina a altura desejada para a imagem
                          //         ),
                          //       ),
                          //       Text(_filteredResults[index].preco),
                          //     ],
                          //   ),
                          // ),
                        );
                      },
                    ),

                  )
              ],
            ),
          ),
        ],
      ),

    );
  }
}
