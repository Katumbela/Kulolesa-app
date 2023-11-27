import 'package:flutter/material.dart';
import 'dart:ui';

class ServicosModel {
  String servico;
  String icon;
  Color boxColor;

  ServicosModel({
    required this.servico,
    required this.icon,
    required this.boxColor,
  });

  static List<ServicosModel> getServices() {
    List<ServicosModel> servicos = [];

    servicos.add(ServicosModel(
      servico: "Acomodação",
      icon: "assets/hotel.png",
      boxColor: const Color(0xd2beffe0),
    ));
    servicos.add(ServicosModel(
      servico: "Experiências",
      icon: "assets/exp.png",
      boxColor: const Color(0xfffffcb0),
    ));
    servicos.add(ServicosModel(
      servico: "Transportes",
      icon: "assets/bus2.jpeg",
      boxColor: const Color(0xff98c8ff),
    ));

    return servicos;
  }
}
