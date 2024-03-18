import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kulolesa/pages/perfil/paginas_meus_servicos/detalhesMeusTranportes.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/meus_servicos_model/meus_servicos_model.dart';
import '../../../models/user_provider.dart';
import '../../detalhestransp.dart';

class TransportesPage extends StatefulWidget {
  @override
  State<TransportesPage> createState() => _TransportesPageState();
}

class _TransportesPageState extends State<TransportesPage> {


  bool _isLoading = true;



  List<TodosMeusTransportes> TodosTransportes = [];

  void _getAllTransp() async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;


    TodosTransportes = await TodosMeusTransportes.getAllTransp(userData!.uniqueID);
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    _getAllTransp() ;

    return Scaffold(

      body: ListView(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              "Clique no serviço para promover, eliminar ou ver quem agendou", textAlign: TextAlign.center, style: TextStyle(
              fontSize: 15
            )
            ),
          ),
          Column(
            children:   _isLoading ? [
              // Pré-carregamento
              for (int i = 0; i < 3; i++) // Adapte o número conforme necessário
                _buildPlaceholderItem(),
            ]
                :  List.generate(
                TodosTransportes.length, (index) {
              final heroTagg = 'traanss'; // Tag única para o Hero

              return Column(
                children: [
                  InkWell(
                    onTap: () {

                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 200),
                          child: DetalhesTodosMeusTransportesPage(
                            transporte: TodosTransportes[index],
                            heroTag: heroTagg,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: "traanss",
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.height * .156,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(color: Colors.blue.withOpacity(.3), width: 1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: TodosTransportes[index].img,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
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
                            const SizedBox(width: 5),
                            Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.height * .15,
                                decoration: BoxDecoration(
                                  // color: Colors.grey.withOpacity(.05),
                                  // border: Border.all(color: Colors.blue.withOpacity(.3), width: 1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.grey[600],
                                                    size: 14.0,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    TodosTransportes[index].local,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                  height: 4
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.arrow_downward_rounded,
                                                    color: Colors.grey[600],
                                                    size: 18.0,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    TodosTransportes[index].destino,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      // fontSize: 15,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                  height: 4
                                              ),
                                            ],
                                          ),

                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.end,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(16)
                )
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
