
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../user_provider.dart';
import '../provider.dart';

class TodosMeusTransportes {

  String descricao;
  String conta;
  String nome;
  String id;
  String local;
  String servico;
  String preco;
  String destino;
  String img;
  Color boxColor;
  bool sponsor;

  TodosMeusTransportes({
    required this.descricao,
    required this.conta,
    required this.id,
    required this.servico,
    required this.img,
    required this.local,
    required this.preco,
    required this.nome,
    required this.destino,
    required this.sponsor,
    required this.boxColor,
  });

  static Future<List<TodosMeusTransportes>> getAllTransp(String uniqueID) async {


    List<TodosMeusTransportes> items = [];

    try {
      final QuerySnapshot transportesSnapshot =
      await FirebaseFirestore.instance.collection('transportes').where('conta', isEqualTo: uniqueID).get();

      for (var transporteDocument in transportesSnapshot.docs) {
        final transporteData =
        transporteDocument.data() as Map<String, dynamic>;

        items.add(TodosMeusTransportes(
          id: transporteDocument.id,
          servico: "Transporte",
          conta: transporteData['conta'] ?? "",
          descricao: transporteData['descricao'] ?? "",
          preco: transporteData['preco'] ?? "0",
          destino: transporteData['onde'] ?? "",
          nome: transporteData['marca'] ?? "",
          local: transporteData['trajecto'] ?? "",
          img: transporteData['imageUrl'] ?? "",
          sponsor: transporteData['sponsor'] ?? false, // Você pode definir isso como desejar
          boxColor: const Color(0xd2beffe0), // Defina a cor conforme necessário
        ));
      }
    } catch (e) {
      print('Erro ao carregar transportes: $e');
    }

    return items;
  }
}


class TodasMinhasActividadesModel {


  String descricao;
  String conta;
  String id;
  String local;
  String servico;
  String preco;
  String actividade;
  String img;
  Color boxColor;
  bool sponsor;

  TodasMinhasActividadesModel({
    required this.descricao,
    required this.id,
    required this.servico,
    required this.img,
    required this.local,
    required this.preco,
    required this.conta,
    required this.actividade,
    required this.sponsor,
    required this.boxColor,
  });

  static Future<List<TodasMinhasActividadesModel>> getAllMineActivities(String uniqueID) async {
    List<TodasMinhasActividadesModel> items = [];

    try {
      final QuerySnapshot actividadesDocumentSnapshot =
      await FirebaseFirestore.instance.collection('actividades').where('conta', isEqualTo: uniqueID).get();

      for (var actividadesDocument in actividadesDocumentSnapshot.docs) {
        final transporteData =
        actividadesDocument.data() as Map<String, dynamic>;

        items.add(TodasMinhasActividadesModel(
          id: actividadesDocument.id,
          servico: "Actividade",
          descricao: transporteData['descricao'] ?? "",
          preco: transporteData['preco'] ?? "0",
          actividade: transporteData['act'] ?? "",
          conta: transporteData['conta'] ?? "",
          local: transporteData['localizacao'] ?? "",
          img: transporteData['img'] ?? "",
          sponsor: transporteData['sponsor'] ?? false, // Você pode definir isso como desejar
          boxColor: const Color(0xd2beffe0), // Defina a cor conforme necessário
        ));
      }
    } catch (e) {
      print('Erro ao carregar transportes: $e');
    }

    return items;
  }
}


class TodasMinhasAcomModel {

  String conta;
  String descricao;
  String id;
  String acom;
  String local;
  String servico;
  String preco;
  String img;
  String avaliacao;
  Color boxColor;
  bool cama;
  bool wifi;
  bool chuveiro;
  bool sinal;
  bool sponsor;



  TodasMinhasAcomModel({
    required this.conta,
    required this.descricao,
    required this.servico,
    required this.id,
    required this.img,
    required this.local,
    required this.preco,
    required this.avaliacao,
    required this.acom,
    required this.wifi,
    required this.chuveiro,
    required this.sinal,
    required this.cama,
    required this.boxColor,
    required this.sponsor,
  });
  static Future<List<TodasMinhasAcomModel>> getTodasMinhasAcom(String uniqueID) async {
    List<TodasMinhasAcomModel> items = [];

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acomodacoes').where('conta', isEqualTo: uniqueID).get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data() as Map<String, dynamic>;

        if (data['conta'] != null &&
            data['descricao'] != null &&
            data['servico'] != null &&
            data['preco'] != null &&
            data['acom'] != null &&
            data['local'] != null &&
            data['avaliacao'] != null &&
            data['img'] != null &&
            data['cama'] != null &&
            data['chuveiro'] != null &&
            data['sinal'] != null &&
            data['wifi'] != null) {
          
          items.add(TodasMinhasAcomModel(
            conta: data['conta'],
            descricao: data['descricao'],
            id: documentSnapshot.id,
            servico: data['servico'],
            preco: data['preco'],
            acom: data['acom'],
            local: data['local'],
            avaliacao: data['avaliacao'],
            img: data['img'],
            boxColor: const Color(0xff98c8ff),
            cama: data['cama'],
            chuveiro: data['chuveiro'],
            sinal: data['sinal'],
            wifi: data['wifi'],
            sponsor: data['sponsor'],
          ));
        }
      }
    } catch (e) {
      print('Erro ao buscar dados do Firestore: $e');
    }
    print(items);
    return items;
  }

}
