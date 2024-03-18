import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:country_state_picker/country_state_picker.dart';
import 'package:flutter/material.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/pages/PaginaExpe.dart';
import 'package:kulolesa/pages/PaginaTransp.dart';
import 'package:kulolesa/pages/detalhesAcom.dart';
import 'package:kulolesa/pages/perfil.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/servicos_model.dart';
import '../models/sponsored_models.dart';
import '../models/user_provider.dart';

class PaginaAcomodacao extends StatefulWidget {
  const PaginaAcomodacao({super.key});

  @override
  State<PaginaAcomodacao> createState() => _PaginaAcomodacaoState();
}

class _PaginaAcomodacaoState extends State<PaginaAcomodacao> {

  List<PatrocinadosAcomModel> sponsoredAcom = [];

  void _getSponsoredAcom() async {
    patrocinadosAcom = await PatrocinadosAcomModel.getSponsoredAcom();
    setState(() {
      _isLoading = false;
    });
  }


  String? selectedCountry;
  String? selectedState;
  String ? selectedCity;

  bool _isLoading = true;


  List<PatrocinadosAcomModel> patrocinadosAcom = [];





  void _applyFilters() {
    setState(() {
      List<PatrocinadosAcomModel> filteredAcom = patrocinadosAcom;

      if (selectedCountry != null) {
        final selectedCounty = selectedCountry; // Remove a bandeira

        print(selectedCounty);
        filteredAcom = filteredAcom
            .where((acomodacao) => acomodacao.pais == selectedCounty)
            .toList();
      }


      if (selectedState != null) {

        final selectedStat = selectedState; // Remove a bandeira
        filteredAcom = filteredAcom
            .where((acomodacao) => acomodacao.estado == selectedStat)
            .toList();
      }


      // if (selectedCity != null) {
      //   filteredAcom = filteredAcom
      //       .where((acomodacao) => acomodacao.cidade == selectedCity)
      //       .toList();
      // }
      // Atualizar a lista de acomodações filtradas
      patrocinadosAcom = filteredAcom;
    });
    print(selectedCountry);
    print(selectedCity);
  }




  void _getSponsoredA() async {
    List<PatrocinadosAcomModel> allSponsorAcom = await PatrocinadosAcomModel.getSponsoredAcom();

    // Filtrar os transportes com sponsor igual a true
    sponsoredAcom = allSponsorAcom.where((acomodacao) => acomodacao.sponsor).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _applyFilters();
  }


  Future<void> _handleRefresh() async {
    // Aguarde um período simulado para dar a sensação de atualização (você pode remover isso)
    await Future.delayed(Duration(seconds: 2));

    // Use o setState para reconstruir a árvore de widgets
    setState(() {
      // Coloque aqui a lógica de atualização se necessário
      _getSponsoredAcom();
      _getSponsoredA();
      _applyFilters();
    });

  }

  @override
  Widget build(BuildContext context) {
    _getSponsoredAcom();
    _getSponsoredA();
    _applyFilters();


    return Scaffold(
      appBar: CustomAppBar(titulo: "Encontre Acomodações",),
      body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            children: [
              _acomPatrocinadaHead(),
              _acomPatrocinada(),
            ],
          ),
        ),
    );
  }




  Column _acomPatrocinada() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 28),
          child: Text(
            "Procurar por...",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(
          height: 5.0,
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:
          CountryStatePicker(
            onCountryChanged: (ct) => setState(() {
              selectedCountry = ct;
              selectedState == null;
              _applyFilters();
            }),
            onStateChanged: (st) => setState(() {
              selectedState = st;
              _applyFilters();
            }),
          ),
          // SelectState(
          //   onCountryChanged: (String? country) {
          //     setState(() {
          //       selectedCountry = country;
          //       selectedState = null;
          //       selectedCity = null;
          //     });
          //
          //     _applyFilters(); // Chame o método _applyFilters() após definir as seleções
          //   },
          //
          //   onStateChanged: (String? state) {
          //     setState(() {
          //       selectedState = state;
          //       selectedCity = null;
          //     });
          //     _applyFilters(); // Chame o método _applyFilters() após definir as seleções
          //   },
          //   onCityChanged: (String? city) {
          //     setState(() {
          //       selectedCity = city;
          //     });
          //     _applyFilters(); // Chame o método _applyFilters() após definir as seleções
          //   },
          //   // Restante das propriedades do SelectState
          // ),
        ),


        const SizedBox(
          height: 20.0,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 28),
          child: Text(
            "Outras acomodações",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: _isLoading
                ? [
              // Pré-carregamento
              for (int i = 0;
              i < 5;
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
                                    .55,
                                child: Text(
                                  acomodacao.acom,
                                  style: const TextStyle(
                                    fontSize: 18.0,
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
                                    size: 14,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width *
                                          .45,
                                      child: Text(
                                        acomodacao.local,style: TextStyle(
                                        fontSize: 12,
                                      ),
                                        overflow: TextOverflow.ellipsis,
                                      )),
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
                                    size: 15,
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
                                            size: 20),
                                        Text(
                                          acomodacao.avaliacao,
                                          style: const TextStyle(
                                              fontSize: 15.0,
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
                                            fontSize: 20,
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

       patrocinadosAcom.length >= 1 ?
       Text("")
           :
       Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Center(
               child: Lottie.asset("assets/notfound2.json", height: 200, width: 200),
           ),
           Container(
             alignment: Alignment.center,
             width: 190,
             child: Text("Não foi encontrado nenhuma acomodação neste local", textAlign: TextAlign.center, style: TextStyle(
               fontSize: 12,

             ),
             ),
           ),
           SizedBox(height: 60),

         ],
       ),
      ],
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
          height: MediaQuery.of(context).size.height * .25, // Defina a altura desejada para a lista horizontal
          child: _isLoading ? _buildPlaceholderItem() : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sponsoredAcom.length,
            itemBuilder: (context, index) {
              final acomodacao = sponsoredAcom[index];
              final heroTag = 'acomodacaoHead_$index'; // Tag única para o Hero

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
                  width: MediaQuery.of(context).size.width * .95, // Defina a largura desejada para cada item
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
            const SizedBox(width: 5, ),
            Expanded(
              child: Container(
                  height: 200,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)
                     ),
                  ),
               ),
            ],
         ),
      ),
    );
  }


}
