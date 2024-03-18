import 'package:flutter/material.dart';
import 'package:kulolesa/widgets/app_bar.dart';

class Privacidade extends StatefulWidget {
  const Privacidade({super.key});

  @override
  _PrivacidadeState createState() => _PrivacidadeState();
}

class _PrivacidadeState extends State<Privacidade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "A sua Privacidade"),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(bottom: 15.0, top: 30.0),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin:
                const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 30.0),
                child: const Text(
                  'A sua privacidade',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: const Text(
                            ' A sua privacidade é importante para nós. É política do Kulolesa respeitar a sua privacidade em relação a qualquer informação sua que possamos coletar no site Kulolesa, e outros sites que possuímos e operamos. \n\n Solicitamos informações pessoais apenas quando realmente precisamos delas para lhe fornecer um serviço. Fazemo-lo por meios justos e legais, com o seu conhecimento e consentimento. Também informamos por que estamos coletando e como será usado.\n\n Apenas retemos as informações coletadas pelo tempo necessário para fornecer o serviço solicitado. Quando armazenamos dados, protegemos dentro de meios comercialmente aceitáveis ​​para evitar perdas e roubos, bem como acesso, divulgação, cópia, uso ou modificação não autorizados.'
                                '\n\n Não compartilhamos informações de identificação pessoal publicamente ou com terceiros, exceto quando exigido por lei.\n'
                                '\n O nosso site pode ter links para sites externos que não são operados por nós. Esteja ciente de que não temos controle sobre o conteúdo e práticas desses sites e não podemos aceitar responsabilidade por suas respectivas políticas de privacidade.\n'
                                '\n Você é livre para recusar a nossa solicitação de informações pessoais, entendendo que talvez não possamos fornecer alguns dos serviços desejados.'
                                '\n O uso continuado de nosso site será considerado como aceitação de nossas práticas em torno de Aviso de Privacidad e informações pessoais.\n\n Se você tiver alguma dúvida sobre como lidamos com dados do usuário e informações pessoais, entre em contacto connosco.', style: TextStyle()),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25, bottom: 12),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Compromisso do usuario",
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: const Text(
                            "O usuário se compromete a fazer uso adequado dos conteúdos e da informação que a Kulolesa oferece no site e com caráter enunciativo, mas não limitativo:"
                                '\n\nA) Não se envolver em atividades que sejam ilegais ou contrárias à boa fé a à ordem pública;'
                                '\n\nB) Não difundir propaganda ou conteúdo de natureza racista, xenofóbica, apostas online ou azar, qualquer tipo de pornografia ilegal, de apologia ao terrorismo ou contra os direitos humanos;'
                                '\n\nC) Não causar danos aos sistemas físicos (hardwares) e lógicos (softwares) do Kulolesa, de seus fornecedores ou terceiros, para introduzir ou disseminar vírus informáticos ou quaisquer outros sistemas de hardware ou software que sejam capazes de causar danos anteriormente mencionados.', style: TextStyle( )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
