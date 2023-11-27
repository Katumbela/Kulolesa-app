import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  String foto;
  String id;
  String nome;
  String email;
  String telefone;
  String nascimento;
  String tipoConta;

  UsuarioModel({
    required this.foto,
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.tipoConta,
    required this.nascimento,
  });



  static Future<List<UsuarioModel>> getUsuarios() async {
    List<UsuarioModel> usuarios = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
      usuarios.add(UsuarioModel(
        id: docSnapshot.id,
        tipoConta: userData['account_type'] ?? '',
        nome: userData['fullName'] ?? '',
        email: userData['email'] ?? '',
        telefone: userData['phone'] ?? '',
        nascimento: userData['birthdate'] ?? '',
        foto: userData['profile_pic'] ?? '',
      ));
    }

    return usuarios;
  }
}
