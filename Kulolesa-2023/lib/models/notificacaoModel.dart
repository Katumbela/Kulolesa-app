import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificacaoModel {
  String id;
  String foto;
  String conteudo;
  bool lido;
  String nome;
  String para;
  DateTime quando;
  String status;

  NotificacaoModel({
    required this.id,
    required this.foto,
    required this.conteudo,
    required this.lido,
    required this.nome,
    required this.para,
    required this.quando,
    required this.status,
  });

  static Future<List<NotificacaoModel>> getMinhasNotificacoes(String uniqueID) async {
    List<NotificacaoModel> items = [];

    try {
      final QuerySnapshot notificacoesSnapshot = await FirebaseFirestore.instance
          .collection('notificacoes')
          .where('para', isEqualTo: uniqueID)
          .get();

      for (var notificacaoDocument in notificacoesSnapshot.docs) {
        final notificacaoData = notificacaoDocument.data() as Map<String, dynamic>;

        items.add(NotificacaoModel(
          id: notificacaoDocument.id,
          foto: notificacaoData['foto'] ?? "",
          conteudo: notificacaoData['conteudo'] ?? "",
          lido: notificacaoData['lido'] ?? false,
          nome: notificacaoData['nome'] ?? "",
          para: notificacaoData['para'] ?? "",
          quando: (notificacaoData['quando'] as Timestamp).toDate(),
          status: notificacaoData['status'] ?? "",
        ));
      }
    } catch (e) {
      print('Erro ao carregar notificações: $e');
    }

    return items;
  }
}
