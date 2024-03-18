import 'package:cloud_firestore/cloud_firestore.dart';


class Servicos {
  String preco;
  DateTime quando;
  String idServico;

  Servicos({
    required this.preco,
    required this.quando,
    required this.idServico,
  });

  static Future<List<Servicos>> getMeusServicos(String uniqueID) async {
    List<Servicos> items = [];

    try {
      final QuerySnapshot transportesSnapshot = await FirebaseFirestore.instance
          .collection('transportes')
          .where('conta', isEqualTo: uniqueID)
          .get();

      for (var transporteDocument in transportesSnapshot.docs) {
        final transporteData = transporteDocument.data() as Map<String, dynamic>;

        items.add(Servicos(
          preco: transporteData['preco'],
          idServico: transporteDocument.id, // Use o ID do documento
          quando: (transporteData['quando'] as Timestamp).toDate(),
        ));
      }

      // Repita o processo para a coleção 'acomodacoes' e 'atividades'
      final QuerySnapshot acomodacoesSnapshot = await FirebaseFirestore.instance
          .collection('acomodacoes')
          .where('conta', isEqualTo: uniqueID)
          .get();

      for (var acomodacaoDocument in acomodacoesSnapshot.docs) {
        final acomodacaoData = acomodacaoDocument.data() as Map<String, dynamic>;


        items.add(Servicos(
          preco: acomodacaoData['preco'],
          idServico: acomodacaoDocument.id,
          quando: (acomodacaoData['quando'] as Timestamp).toDate(),
        ));

      }

      // Repita o processo para a coleção 'atividades' (se necessário)
      final QuerySnapshot atividadesSnapshot = await FirebaseFirestore.instance
          .collection('actividades')
          .where('conta', isEqualTo: uniqueID)
          .get();

      for (var atividadeDocument in atividadesSnapshot.docs) {
        final atividadeData = atividadeDocument.data() as Map<String, dynamic>;

        items.add(Servicos(
          preco: atividadeData['preco'],
          idServico: atividadeDocument.id,
          quando: (atividadeData['quando'] as Timestamp).toDate(),
        ));
      }
    } catch (e) {
      print('Erro ao carregar serviços: $e');
    }

    print(items);
    return items;
  }
}
