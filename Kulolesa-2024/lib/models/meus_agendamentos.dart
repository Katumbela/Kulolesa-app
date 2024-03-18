import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Agendamento {
  String preco;
  String tipoServico;
  String quando;
  String idServico;

  Agendamento({
    required this.tipoServico,
    required this.preco,
    required this.quando,
    required this.idServico,
  });

  static Future<List<Agendamento>> getMeusAgendamentos(String uniqueID) async {
    List<Agendamento> items = [];

    try {
      final QuerySnapshot notificacoesSnapshot = await FirebaseFirestore.instance
          .collection('agendamentos')
          .where('idUsuario', isEqualTo: uniqueID)
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

          items.add(Agendamento(
            tipoServico: notificacaoData['servico'] ?? "Removido",
            preco: notificacaoData['preco'] ?? "Removido",
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

          items.add(Agendamento(
            tipoServico: notificacaoData['servico'] ?? "Removido",
            preco: notificacaoData['preco'] ?? "Removido",
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
