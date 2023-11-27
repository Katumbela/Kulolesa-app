// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../estilos/estilo.dart';
import '../models/notificacaoModel.dart';
import '../models/user_provider.dart';
// import 'detalhesAcom.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List<NotificacaoModel> notificacoes = [];


  bool _isLoading = true;

  void _getMinhasNotificacoes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.user;

    String yourUniqueID = userData!.uniqueID;
    List<NotificacaoModel> minhasNotificacoes =
    await NotificacaoModel.getMinhasNotificacoes(yourUniqueID);

    // Ordenar por data mais recente
    minhasNotificacoes.sort((a, b) => b.quando.compareTo(a.quando));

    // Formato de data desejado

    // Formatar as datas e atualizar o estado
    setState(() {
      notificacoes = minhasNotificacoes
          .map((notificacao) => NotificacaoModel(
        // Aqui você pode atribuir os outros valores da notificação
        conteudo: notificacao.conteudo,
        foto: notificacao.foto,
        lido: notificacao.lido,
        nome: notificacao.nome,
        para: notificacao.para,
        status: notificacao.status,
        id: notificacao.id,
        // ... outros atributos ...
        quando: notificacao.quando,
      ))
          .toList();
      _isLoading = false;
    });
  }


  late final d = "de";

  final dateFormat = DateFormat('HH:mm dd MM, yyyy'); // Formato de data desejado



  Future<void> _handleRefresh() async {
    // Aguarde um período simulado para dar a sensação de atualização (você pode remover isso)
    await Future.delayed(Duration(seconds: 3));

    // Use o setState para reconstruir a árvore de widgets
    setState(() {
      // Coloque aqui a lógica de atualização se necessário
      _getMinhasNotificacoes();
    });
  }



  @override
  void initState() {
    super.initState();
    _getMinhasNotificacoes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Notificações"),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          children: _isLoading
              ? [
            // Pré-carregamento
            for (int i = 0; i < 5; i++) // Adapte o número conforme necessário
              _buildPlaceholderItem(),
          ]
              : notificacoes.map((notificacao) {
            final formattedDate = dateFormat.format(notificacao.quando);

            return Dismissible(
              key: UniqueKey(), // Use uma chave única para cada item
              onDismissed: (direction) async {
                // Quando o item for arrastado, exclua-o do Firestore
                try {
                  await FirebaseFirestore.instance
                      .collection('notificacoes')
                      .doc(notificacao.id)
                      .delete();

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                          'Notificação removida com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  print('Erro ao excluir notificação: $e');
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                          'Erro ao remover item!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  // Lide com o erro aqui, se necessário
                }


              },
              background: Container(
                color: Colors.red, // Cor de fundo ao arrastar
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 30,
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
              ),
              child: GestureDetector(
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1D1617).withOpacity(.02),
                        blurRadius: 40,
                        offset: const Offset(0, 10),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: InkWell(
                          onTap: null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(100.0),
                              child: CachedNetworkImage(
                                imageUrl: notificacao.foto,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
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
                      Container(
                        width: MediaQuery.of(context).size.width * .60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              formattedDate,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .55,
                              child: Text(notificacao.conteudo),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        )

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

            Expanded(
              child: Container(
                  height: 105,
                  width: MediaQuery.of(context).size.width *.9,
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
