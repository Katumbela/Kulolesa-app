import 'dart:ui';

class Dados {
  static List<Resultado> resultadosPesquisa = [
    Resultado(
      local: 'Local 1',
      foto: 'assets/car1.jpeg', // Substitua pelo caminho correto da imagem
      preco: 'R\$ 100,00',
    ),
    Resultado(
      local: 'Local 2',
      foto: 'assets/car3.jpeg', // Substitua pelo caminho correto da imagem
      preco: 'R\$ 150,00',
    ),
    Resultado(
      local: 'Local 3',
      foto: 'assets/car2.jpeg', // Substitua pelo caminho correto da imagem
      preco: 'R\$ 120,00',
    ),
    Resultado(
      local: 'Local 4',
      foto: 'assets/car7.jpg', // Substitua pelo caminho correto da imagem
      preco: 'R\$ 180,00',
    ),
    Resultado(
      local: 'Local 5',
      foto: 'assets/car6.png', // Substitua pelo caminho correto da imagem
      preco: 'R\$ 90,00',
    ),
  ];
}

class Resultado {
  final String local;
  final String foto;
  final String preco;

  Resultado({
    required this.local,
    required this.foto,
    required this.preco,
  });
}


class DadosTransp {
  static List<ResultadoTrans> resultadosPesquisaTransp = [

    ResultadoTrans(
      id: "akjhsjhsjfcbnd",
      servico: "Transporte",
      preco: "12.000",
      destino: "Huambo",
      nome: "Chevrolet Spark",
      local: "Angola",
      img: "assets/car2.jpeg",
      sponsor: true,
      boxColor: const Color(0xd2beffe0),
    ),
    ResultadoTrans(
      id: "akjhsjhsjfcbnd",
      servico: "Transporte",
      preco: "12.000",
      destino: "Huambo",
      nome: "Chevrolet Spark",
      local: "Angola",
      img: "assets/car5.png",
      sponsor: true,
      boxColor: const Color(0xd2beffe0),
    ),
    ResultadoTrans(
      id: "akjhsjhsjfcbnd",
      servico: "Transporte",
      preco: "12.000",
      destino: "Huambo",
      nome: "Hyundai i10",
      local: "Angola",
      img: "assets/car1.jpeg",
      sponsor: true,
      boxColor: const Color(0xd2beffe0),
    ),
  ];
}

class ResultadoTrans {
  String nome;
  String id;
  String local;
  String servico;
  String preco;
  String destino;
  String img;
  Color boxColor;
  bool sponsor;

  ResultadoTrans({
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
}

