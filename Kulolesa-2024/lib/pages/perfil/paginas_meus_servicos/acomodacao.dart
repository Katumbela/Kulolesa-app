import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kulolesa/pages/perfil/paginas_meus_servicos/detalhesMinhasAcom.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../estilos/estilo.dart';
import '../../../models/meus_servicos_model/meus_servicos_model.dart';
import '../../../models/user_provider.dart';
import '../../detalhesAcom.dart';

class AcomodacaoPage extends StatefulWidget {
  @override
  State<AcomodacaoPage> createState() => _AcomodacaoPageState();
}

class _AcomodacaoPageState extends State<AcomodacaoPage> {


  List<TodasMinhasAcomModel> patrocinadosAcom = [];
  bool _isLoading = true;


  void _getSponsored() async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;
    final uniqueID = userData!.uniqueID;

    patrocinadosAcom = await TodasMinhasAcomModel.getTodasMinhasAcom(uniqueID);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getSponsored();

    return Scaffold(

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Center(
              child: Text('Suas acomodações no aplicativo'),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: _isLoading
                  ? [
                // Pré-carregamento
                for (int i = 0;
                i < 3;  i++) // Adapte o número conforme necessário
                  _buildPlaceholderItem(),
              ]
                  : List.generate(
                patrocinadosAcom.length,
                    (index) {
                      final acomodacao = patrocinadosAcom[index];
                  final heroTag =
                      'acomod_$index'; // Tag única para o Hero


                    return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesMinhasAcomodacaoPage(
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
            const SizedBox(width: 5, ),
            Expanded(
              child: Container(
                height: 100,
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
