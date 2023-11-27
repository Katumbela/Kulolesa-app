import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/meus_servicos_model/meus_servicos_model.dart';
import '../../../models/user_provider.dart';
import 'detalhesMinhasActividades.dart';

class AtividadePage extends StatefulWidget {
  @override
  State<AtividadePage> createState() => _AtividadePageState();
}

class _AtividadePageState extends State<AtividadePage> {


  List<TodasMinhasActividadesModel> TodasActividades = [];

bool _isLoading = true;

  void _getAllTransp() async {


    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;
    final uniqueID = userData!.uniqueID;

    TodasActividades = await TodasMinhasActividadesModel.getAllMineActivities(uniqueID);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getAllTransp();

    return Scaffold(

      body:
      ListView(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text("Suas actividades no aplicativo", style: TextStyle(
              fontSize: 15.0,
            ),),
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
                          builder: (context) => DetalheMinhasActividades(
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
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),

                            Container(
                              height: MediaQuery.of(context).size.height * .135,
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
                                          fontSize: 22,
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
                                              size: 18.0,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              TodasActividades[index].local,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 15,
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
                                                fontSize: 22.0,
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
}
