import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/pages/login_page.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/provider.dart';
import '../models/user_provider.dart';
import 'inicio.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  CountryCode? _selectedCountry;

  String getFullPhoneNumber() {
    String phoneNumber = _selectedCountry != null
        ? "${_selectedCountry!.dialCode} ${_phoneController.text}"
        : _phoneController.text;
    return phoneNumber;
  }

  bool _isLoading = false;
  bool _passwordVisible = false;

  void _showSnackbar(String message, {bool isError = true}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  DateTime noww = DateTime.now();
  late String formattedDate = DateFormat('yyyy-MM-dd').format(noww);

  Future<void> addDataToFirestore(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final formattedDate = DateTime
          .now(); // Certifique-se de que 'formattedDate' está definido corretamente

      String phoneNumber = getFullPhoneNumber();

      await FirebaseFirestore.instance.collection('users').add({
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phone': phoneNumber,
        'birthdate': _birthdateController.text,
        'password': _passwordController.text,
        "account_type": "Usuario",
        "profile_pic":
            "https://firebasestorage.googleapis.com/v0/b/kulolesaapp.appspot.com/o/perfil%2Fdefault.png?alt=media&token=0240187d-8b96-48e5-80de-f41a16d527fd",
        "data_cadastro": formattedDate,
      });

      setState(() {
        _isLoading = false;
      });
      print('Conta criada com sucesso');

      _signInWithEmailAndPassword(context);
    } catch (e) {
      String errorMessage = 'Ocorreu um erro ao criar sua conta.';

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
                'O email já está em uso. Insira outro ou faça login.';
            break;
          case 'invalid-email':
            errorMessage = 'O email fornecido é inválido.';
            break;
          case 'weak-password':
            errorMessage = 'A senha é fraca. Escolha uma senha mais forte.';
            break;
          // Adicione mais casos para outros códigos de erro do FirebaseAuth, se necessário.
        }
      }

      setState(() {
        _isLoading = false;
      });
      print('Ocorreu um erro ao criar sua conta: $e');
      _showSnackbar(errorMessage, isError: true);
    }
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Autenticação bem-sucedida
        print("Authentication successful");

        // Agora, obtenha os dados do usuário do Firestore
        final userQuerySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: _emailController.text)
            .limit(1)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          final userDocument = userQuerySnapshot.docs.first;
          final userData = userDocument.data() as Map<String, dynamic>;

          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final userDataObject = UserData.fromMap({
            ...userData,
            'uniqueID': userDocument.id,
          });
          userProvider.setUser(userDataObject);

          // Configurar o usuário no armazenamento persistente
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('uniqueID', userDocument.id);

          setState(() {
            _isLoading = false;
          });

          // Navegue para a página Inicio() após o login bem-sucedido
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 200),
              child: const Inicio(),
            ),
          );
        } else {
          _showSnackbar('Usuário não encontrado.');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        _showSnackbar('Erro de autenticação. Tente novamente.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackbar('Ocorreu um erro aorro ao fazer login: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(dynamic error) {
    String errorMessage;
    Color snackBarColor;

    if (error is FirebaseException) {
      if (error.code == 'user-not-found' || error.code == 'wrong-password') {
        errorMessage = 'Email ou senha incorretos. Tente novamente.';
        snackBarColor = Colors.red; // Erro de dados errados
      } else if (error.code == 'timeout' || error.code == 'no-internet') {
        errorMessage =
            'Erro de conexão ou tempo de requisição excedido, tente novamente.';
        snackBarColor = Colors.orange; // Aviso de erro de conexão
      } else {
        errorMessage = ' $error';
        snackBarColor = Colors.orange; // Outros erros
      }
    } else {
      errorMessage = '  $error';
      print(error);
      snackBarColor = Colors.red; // Outros erros
    }

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: snackBarColor,
      ),
    );
  }

  bool _canRegister() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _birthdateController.text.isNotEmpty &&
        _selectedCountry != null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      _birthdateController.text = DateFormat("dd/MM/yyyy").format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titulo: ""),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 2),
                child: Text(
                  "Vamos começar por criar a sua conta",
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _emailController,
                // decoration: InputDecoration(labelText: 'Email'),
                style: EstiloApp.estiloTexto
                    .copyWith(color: Colors.blue), // Define a cor do texto
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Digite seu email",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  labelStyle:
                      TextStyle(color: Colors.blue), // Define a cor do rótulo

                  // Define a cor das bordas e a forma do contorno
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 14, top: 28),
                child: TextFormField(
                  controller: _passwordController,
                  style: EstiloApp.estiloTexto
                      .copyWith(color: Colors.blue), // Define a cor do texto
                  decoration: InputDecoration(
                    labelText: "Senha",
                    hintText: "Crie uma senha",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                          color: Colors.blue),
                    ),

                    labelStyle:
                        TextStyle(color: Colors.blue), // Define a cor do rótulo

                    // Define a cor das bordas e a forma do contorno
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  obscureText: !_passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha.';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: TextField(
                  style: EstiloApp.estiloTexto
                      .copyWith(color: Colors.blue), // Define a cor do texto
                  decoration: InputDecoration(
                    labelText: "Nome completo",
                    hintText: "Nome completo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    labelStyle:
                        TextStyle(color: Colors.blue), // Define a cor do rótulo

                    // Define a cor das bordas e a forma do contorno
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  controller: _fullNameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  style: EstiloApp.estiloTexto,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    hintText: "Insira seu telefone",
                    prefixIcon: CountryCodePicker(
                      initialSelection: 'AO', // País inicialmente selecionado
                      favorite: ['AO', 'PT'], // Países favoritos
                      onChanged: (CountryCode? countryCode) {},
                    ),


                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),


                    labelStyle: TextStyle(color: Colors.blue), // Define a cor do rótulo


                    // Define a cor das bordas e a forma do contorno
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),


                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),

                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: TextField(
                      controller: _birthdateController,
                      style: EstiloApp.estiloTexto.copyWith(
                          color: Colors.blue), // Define a cor do texto
                      decoration: InputDecoration(
                        labelText: "Nascimento",
                        hintText: "Data de Nascimento",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),


                        labelStyle: const TextStyle( color: Colors.blue), // Define a cor do rótulo


                        // Define a cor das bordas e a forma do contorno
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.25),
                child: ElevatedButton(
                  onPressed: () => addDataToFirestore(context),
                  style: ElevatedButton.styleFrom(
                    primary:
                        Colors.blue[700], // Define a cor de fundo azul[700]
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: const CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Próximo',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.arrow_forward,
                                size: 15, color: Colors.white)
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate to the login screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text('Já tem uma conta? Faça login'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ao clicar em "Cadastrar", você concorda com nossos Termos de Uso e Política de Privacidade.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
