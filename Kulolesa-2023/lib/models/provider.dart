class UserData {
  String uniqueID;
  String fullName;
  String email;
  String phone;
  String birthdate;
  String accountType;
  String profilePic; // Corrigido o nome do campo
  String password; // Adicionado o campo
  // Adicione mais campos conforme necessário

  UserData({
    required this.uniqueID,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.accountType,
    required this.profilePic,
    required this.password,
    // Inclua os outros campos aqui
  });

  UserData.fromMap(Map<String, dynamic> map)
      : uniqueID = map['uniqueID'],
        fullName = map['fullName'],
        email = map['email'],
        phone = map['phone'],
        birthdate = map['birthdate'],
        accountType = map['account_type'],
        profilePic = map['profile_pic'],
        password = map['password'];

// Mapeie os outros campos aqui
}
