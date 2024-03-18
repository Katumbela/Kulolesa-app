import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kulolesa/models/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {

  UserData? _user;

  UserData? get user => _user;

  void setUser(UserData userData) {
    _user = userData;
    notifyListeners();
  }
  Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      String? uniqueID = prefs.getString('uniqueID');
      if (uniqueID != null) {
        // Carregar os dados do usuário do Firestore usando o uniqueID
        final userDocument = FirebaseFirestore.instance
            .collection('users')
            .doc(uniqueID);

        final snapshot = await userDocument.get();
        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;

          // Configurar o usuário no UserProvider
          setUser(UserData(
            uniqueID: uniqueID,
            fullName: userData['fullName'],
            email: userData['email'],
            phone: userData['phone'],
            birthdate: userData['birthdate'],
            accountType: userData['account_type'],
            profilePic: userData['profile_pic'],
            password: userData['password'],
            // Adicione outros campos conforme necessário
          ));
        }
      }
    }
  }

}
