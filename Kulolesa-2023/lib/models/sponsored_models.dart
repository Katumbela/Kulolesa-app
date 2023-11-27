
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:intl/intl.dart';


class TodosTranspModel {

  String descricao;
  String conta;
  String nome;
  String id;
  String local;
  String servico;
  String preco;
  String destino;
  String lugares;
  String dataPartida;
  String img;
  Color boxColor;
  bool sponsor;

  TodosTranspModel({
    required this.lugares,
    required this.descricao,
    required this.conta,
    required this.dataPartida,
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

  static Future<List<TodosTranspModel>> getAllTransp() async {
    List<TodosTranspModel> items = [];

    try {
      final QuerySnapshot transportesSnapshot =
      await FirebaseFirestore.instance.collection('transportes').where("aprovado", isEqualTo: true).get();

      for (var transporteDocument in transportesSnapshot.docs) {
        final transporteData =
        transporteDocument.data() as Map<String, dynamic>;

        items.add(TodosTranspModel(
          id: transporteDocument.id,
          servico: "Transporte",
          dataPartida: transporteData['dataPartida'] ?? "",
          conta: transporteData['conta'] ?? "",
          descricao: transporteData['descricao'] ?? "",
          preco: transporteData['preco'] ?? "0",
          destino: transporteData['onde'] ?? "",
          nome: transporteData['marca'] ?? "",
          local: transporteData['trajecto'] ?? "",
          img: transporteData['imageUrl'] ?? "",
          lugares: transporteData['lugares'] ?? "",
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


class TodasActividadesModel {

  String descricao;
  String conta;
  String pais;
  String cidade;
  String estado;
  String id;
  String local;
  String servico;
  String preco;
  String actividade;
  String img;
  Color boxColor;
  bool sponsor;

  TodasActividadesModel({
    required this.descricao,
    required this.id,
    required this.servico,
    required this.img,
    required this.cidade,
    required this.pais,
    required this.estado,
    required this.local,
    required this.preco,
    required this.conta,
    required this.actividade,
    required this.sponsor,
    required this.boxColor,
  });

  static Future<List<TodasActividadesModel>> getAllActivities() async {
    List<TodasActividadesModel> items = [];

    try {
      final QuerySnapshot actividadesDocumentSnapshot =
      await FirebaseFirestore.instance.collection('actividades').where("aprovado", isEqualTo: true).get();

      for (var actividadesDocument in actividadesDocumentSnapshot.docs) {
        final transporteData =
        actividadesDocument.data() as Map<String, dynamic>;

        items.add(TodasActividadesModel(
          id: actividadesDocument.id,
          servico: "Actividade",
          descricao: transporteData['descricao'] ?? "",
          preco: transporteData['preco'] ?? "0",
          pais: transporteData['pais'] ?? "0",
          cidade: transporteData['cidade'] ?? "0",
          estado: transporteData['estado'] ?? "0",
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


class PatrocinadosAcomModel {

  String conta;
  String pais;
  String cidade;
  String estado;
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



  PatrocinadosAcomModel({
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
    required this.cidade,
    required this.pais,
    required this.estado,
    required this.boxColor,
    required this.sponsor,
  });
  static Future<List<PatrocinadosAcomModel>> getSponsoredAcom() async {
    List<PatrocinadosAcomModel> items = [];

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acomodacoes').where("aprovado", isEqualTo: true).get();

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
          items.add(PatrocinadosAcomModel(
            conta: data['conta'],
            pais: data['pais'],
            cidade: data['cidade'],
            estado: data['estado'],
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

    return items;
  }

}


class ReviewsAcomModel {
  String idAcom;
  Color boxColor;
  String quemId;
  String coment;
  var rating;
  String servico;
  String data;

  ReviewsAcomModel({
    required this.servico,
    required this.data,
    required this.rating,
    required this.idAcom,
    required this.quemId,
    required this.coment,
    required this.boxColor,
  });

  static Future<List<ReviewsAcomModel>> getReviewAcom(id) async {
    List<ReviewsAcomModel> items = [];

    try {
      final QuerySnapshot reviewsSnapshot =
      await FirebaseFirestore.instance.collection('reviews').where("idAcom", isEqualTo: id).get();

      for (var reviewDocument in reviewsSnapshot.docs) {
        final reviewData = reviewDocument.data() as Map<String, dynamic>;

        items.add(
          ReviewsAcomModel(
            idAcom: reviewDocument.id,
            servico: reviewData['servico'] ?? "",
            rating: reviewData['rating'],
            data: reviewData['data'] ?? "",
            quemId: reviewData['quemId'] ?? "",
            coment: reviewData['coment'] ?? "",
            boxColor: Color(int.parse(reviewData['boxColor'])),
          ),
        );
      }
    } catch (e) {
      print('Erro ao buscar avaliações do Firestore: $e');
    }

    // print(items[0].coment);
    return items;
  }
}


class MeusAgendamentos {
  String preco;
  String tipoServico;
  String quemID;
  String quando;
  int lugares;
  String idServico;

  MeusAgendamentos({
    required this.tipoServico,
    required this.lugares,
    required this.preco,
    required this.quemID,
    required this.quando,
    required this.idServico,
  });


  static Future<List<MeusAgendamentos>> getTodosMeusAgendamentos(String uniqueIDServ) async {
    List<MeusAgendamentos> items = [];

    try {
      final QuerySnapshot notificacoesSnapshot = await FirebaseFirestore.instance
          .collection('agendamentos')
          .where('idServico', isEqualTo: uniqueIDServ)
          .get();

      for (var notificacaoDocument in notificacoesSnapshot.docs) {
        final notificacaoData = notificacaoDocument.data() as Map<String, dynamic>;

        Timestamp? quandoTimestamp = notificacaoData['quando'] as Timestamp?;
        Timestamp? dataEntradaTimestamp = notificacaoData['dataEntrada'] as Timestamp?;
        Timestamp? dataSaidaTimestamp = notificacaoData['dataSaida'] as Timestamp?;

        if (quandoTimestamp != null && dataEntradaTimestamp != null && dataSaidaTimestamp != null) {
          DateTime quando = quandoTimestamp.toDate();
          DateTime dataEntrada = dataEntradaTimestamp.toDate();
          DateTime dataSaida = dataSaidaTimestamp.toDate();

          String formattedQuando = DateFormat('dd/MM/yyyy').format(quando);
          String formattedDataEntrada = DateFormat('dd/MM/yyyy').format(dataEntrada);
          String formattedDataSaida = DateFormat('dd/MM/yyyy').format(dataSaida);

          items.add(MeusAgendamentos(
            tipoServico: notificacaoData['servico'] ?? "Removido",
            preco: notificacaoData['preco'] ?? "Removido",
            lugares: notificacaoData['numero_de_lugares'] ?? 0,
            quemID: notificacaoData['idUsuario'] ?? "",
            idServico: notificacaoData['idServico'] ?? "Removido",
            quando: formattedQuando + "@" + formattedDataEntrada + "@" + formattedDataSaida,
          ));
        }

        else {
          DateTime? quando = quandoTimestamp?.toDate();
          DateTime dataEntrada = DateTime.now();
          DateTime dataSaida = DateTime.now();

          String formattedQuando = DateFormat('dd/MM/yyyy').format(quando!);
          String formattedDataEntrada = DateFormat('dd/MM/yyyy').format(dataEntrada);
          String formattedDataSaida = DateFormat('dd/MM/yyyy').format(dataSaida);

          items.add(MeusAgendamentos(
            tipoServico: notificacaoData['servico'] ?? "Removido",
            lugares: notificacaoData['numero_de_lugares'] ?? 0,
            preco: notificacaoData['preco'] ?? "Removido",
            quemID: notificacaoData['idUsuario'] ?? "",
            idServico: notificacaoData['idServico'] ?? "Removido",
            quando: formattedQuando + "@" + formattedDataEntrada + "@" + formattedDataSaida,
          ));
        }
      }
    } catch (e) {
      print('Erro ao carregar notificações: $e');
    }


    return items;
  }
}
