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

  // Future<void> _signInWithEmailAndPassword(BuildContext context) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('email', isEqualTo: _emailController.text)
  //         .limit(1)
  //         .get();
  //
  //     if (usersSnapshot.docs.isNotEmpty) {
  //       final userDocument = usersSnapshot.docs.first;
  //       final userData = userDocument.data() as Map<String, dynamic>;
  //
  //       if (userData['password'] == _passwordController.text) {
  //         // Autenticação bem-sucedida
  //         print(userData);
  //         // Defina o usuário no UserProvider
  //         final userProvider =
  //         Provider.of<UserProvider>(context, listen: false);
  //         final userDataObject = UserData.fromMap({
  //           ...userData,
  //           'uniqueID': userDocument.id,
  //         });
  //         userProvider.setUser(userDataObject);
  //
  //         // Configurar o usuário no armazenamento persistente
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         await prefs.setBool('isLoggedIn', true);
  //         await prefs.setString('uniqueID', userDocument.id);
  //
  //         setState(() {
  //           _isLoading = false;
  //         });
  //
  //         // Navegue para a página Inicio() após o login bem-sucedido
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const Inicio()),
  //         );
  //       } else {
  //         _showErrorSnackBar('Email ou senha incorretos. Tente novamente.');
  //       }
  //     } else {
  //       _showErrorSnackBar('Usuário não encontrado.');
  //     }
  //   } catch (e) {
  //     _showErrorSnackBar('Erro ao fazer login: $e');
  //   }
  // }


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
        backgroundColor: Colors.blue.shade500,
      ),
      body:  ListView(
            children: <Widget> [
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .3,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade500,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200),
                    )
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                    child: Icon(Icons.perm_identity_outlined, color: Colors.white, size: 120,),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _emailController,
                    style: EstiloApp.estiloTexto,
                    decoration: EstiloApp.estiloTextField(
                        label: "Email", hint: "Digite seu email"),
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
                        style: EstiloApp.estiloTexto,
                        decoration: EstiloApp.estiloTextField(
                            label: "Senha", hint: "Insira sua senha"),
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
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    // style: EstiloApp.botaoElevado,
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading == true
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Entrar'),
                  ),
                ),

                const SizedBox(height: 16),

                // ElevatedButton(
                //
                //   onPressed: () {
                //     // Navigate to the login screen
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => Inicio()));
                //
                //   },
                //   child: Text('Pagina Home'),
                // ),// Adicione um espaço entre o botão e o final da tela
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
                        color: Colors.blue.shade400,
                    ),),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: MediaQuery.of(context).size.width * .5,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text("Não tem uma conta ?",
                          style: TextStyle(
                            fontSize: 10,
                          ),),
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
                              fontSize: 10,
                              color: Colors.blue[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // InkWell(
                //
                //   child: const Text(
                //     "  Home",
                //     style: TextStyle(
                //       color: Colors.blueAccent,
                //     ),
                //   ),
                // )
              ],
            ),]
          ),


    );
  }
}
