import 'package:flutter/material.dart';
import 'package:kulolesa/widgets/app_bar.dart';


class Termos extends StatefulWidget {
  const Termos({super.key});

  @override
  _TermosState createState() => _TermosState();
}

class _TermosState extends State<Termos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: "Termos de serviços"),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 18.0),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Kulolesa App",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                    ' Ao navegar neste aplicativo, você está automaticamente de acordo com nossa política. Do contrário, orientamos a que suspenda a navegação no aplicativo e evite concluir o seu cadastro.'
                        '\n\nA política  poderá ser editada a qualquer momento, mas, caso isso aconteça, publicaremos no aplicativo, com a data de revisão atualizada. Por outro lado, se as alterações forem substanciais, nós teremos o cuidado, além de divulgar no aplicativo, de informá-lo por meio das informações de contato que tivermos em nosso cadastro, ou por meio de notificações.'
                        '\n\nA utilização deste aplicativo após as alterações significa que você aceitou a política revisada. Caso, após a leitura da nova versão, você não esteja de acordo com seus termos, favor encerrar o seu acesso.'),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Capitulo 1 - Usuário",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: const Text(
                      'A utilização deste aplicativo atribui de forma automática a condição de usuário e implica a plena aceitação de todas as diretrizes e condições incluídas nestes Termos.'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Capítulo 2 - Adesão em conjunto com a Política de Privacidade",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: const Text(
                      'A utilização deste aplicativo acarreta a adesão à presente Política de Uso e à versão mais atualizada da Política de Privacidade de Kulolesa.'),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Capítulo 3 - Condições de acesso",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue[700],
                      fontFamily: "pp2",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: const Text(
                      'Para usufruir de algumas funcionalidades, o usuário poderá precisar efetuar um cadastro, criando uma conta de usuário com login e senha próprios para acesso.'
                          '\n\n Toda e qualquer publicação de serviço deverá ser revisado primerio antes de ser apresentado para potenciais usuários e só depois da revisão será aprovado ou negado de estar no aplicativo'
                          '\n\n É de total responsabilidade do usuário fornecer apenas informações corretas, autênticas, válidas, completas e atualizadas, bem como não divulgar o seu login e senha para terceiros.'
                          '\n\n Partes deste aplicativo oferecem ao usuário a opção de publicar feedbacks e serviços em campos dedicados. Kulolesa não consente com publicações discriminatórias, ofensivas ou ilícitas, ou ainda infrinjam direitos de autor ou quaisquer outros direitos de terceiros.'
                          '\n\n A publicação de quaisquer conteúdos pelo usuário deste aplicativo, incluindo, mas não se limitando, a  serviços e feedbacks, implica licença não-exclusiva, irrevogável e irretratável, para sua utilização, reprodução e publicação pela Kulolesa em seu aplicativo, plataformas e aplicações de internet, ou ainda em outras plataformas, sem qualquer restrição ou limitação.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

