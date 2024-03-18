import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kulolesa/estilos/estilo.dart';
import 'package:kulolesa/pages/criar_conta.dart';
import 'package:kulolesa/pages/inicio.dart';
import 'package:kulolesa/pages/recuperar_senha.dart';
import 'package:kulolesa/widgets/app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _keepLoggedIn = false;


  Future<void> _signInWithEmailAndPassword(BuildContext context) async {

    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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

          final userProvider = Provider.of<UserProvider>(context, listen: false);
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
              child: BottomNavBar(),
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
      _showSnackbar(' $e');
      setState(() {
        _isLoading = false;
      });
    }

  }

  void _showSnackbar(dynamic error) {
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
      } else if (error.code == 'too-many-requests') {
        errorMessage = 'Acesso a esta conta foi temporariamente bloqueado devido a várias tentativas de login malsucedidas. Tente novamente mais tarde.';
        snackBarColor = Colors.red; // Erro de muitas tentativas de login
      } else {
        errorMessage = 'Email ou senha errada, tente novamente ou recupere sua senha';
        snackBarColor = Colors.orange; // Outros erros
      }
    } else {
      errorMessage = 'Email ou senha errada, tente novamente ou recupere sua senha';
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

  bool _isPasswordVisible =
      false; // Variável para controlar a visibilidade da senha

  Future _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    await _signInWithEmailAndPassword(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body:  ListView(
            children: <Widget> [
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
                  child: Text("Bem vindo de volta, faça login para continuar!",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),


                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(

                    controller: _emailController,
                    style: EstiloApp.estiloTexto.copyWith(color: Colors.blue), // Define a cor do texto
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_outlined, size: 20, color: Colors.blue,),
                      labelText: "Email",
                      hintText: "Digite seu email",

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


                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 20.0),

                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: _passwordController,
                        style: EstiloApp.estiloTexto.copyWith(color: Colors.blue), // Define a cor do texto
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_open_sharp, size: 20, color: Colors.blue),
                          labelText: "Senha",
                          hintText: "Insira sua senha",
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

                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        ),
                        obscureText: !_isPasswordVisible,
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },

                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 0),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),

                  child:
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Inverta o estado quando o texto for clicado
                          setState(() {
                            _keepLoggedIn = !_keepLoggedIn;
                          });
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: _keepLoggedIn,
                              onChanged: (value) {
                                setState(() {
                                  _keepLoggedIn = value ?? false;
                                });
                              },
                            ),
                            Text(
                              "Manter-me logado",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ),

                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.35),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[700], // Define a cor de fundo azul[700]
                    ),
                    child: _isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator( color: Colors.white,),
                    )
                        : Text('Entrar', style: TextStyle(color: Colors.white), ),
                  ),
                ),



                SizedBox(height: 15), // Espaço entre o TextField e a linha "Ou"


                Center(
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 250),
                          child:  PasswordResetPage(),
                        ),
                      )
                    },

                    child: Text("Esqueceu sua senha ?", style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                    ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(

                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12,vertical: MediaQuery.of(context).size.width * 0.01),

                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.blue[700], thickness: .4,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Ou", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                      Expanded(
                        child: Divider(color: Colors.blue[700], thickness: .4,),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20), // Espaço entre a linha "Ou" e o texto "Criar conta"


                Container(
                  width: MediaQuery.of(context).size.width * .5,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CadastroPage()));
                          },
                          child: Text(
                            "  Crie uma conta",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


              ],
            ),]
          ),


    );
  }
}
