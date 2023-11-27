class SaudacaoService {
  String getMensagemSaudacao(String userName) {
    final horaAtual = DateTime.now().hour;

    if (horaAtual >= 0 && horaAtual < 12) {
      return "Bem-vindo(a), ${_primeiroNome(userName)}!";
    } else if (horaAtual >= 12 && horaAtual < 18) {
      return "Bem-vindo(a), ${_primeiroNome(userName)}!";
    } else {
      return "Bem-vindo(a), ${_primeiroNome(userName)}!";
    }
  }

  String _primeiroNome(String fullName) {
    List<String> partesNome = fullName.split(" ");
    if (partesNome.isNotEmpty) {
      return partesNome.first;
    }
    return fullName;
  }
}
