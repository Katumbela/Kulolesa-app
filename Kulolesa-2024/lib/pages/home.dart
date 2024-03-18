import 'package:flutter/material.dart';
import 'package:kulolesa/pages/criar_conta.dart';
import 'package:kulolesa/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/provider.dart';
import '../models/user_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // if (isLoggedIn == false) {  // Correção: Usar "=="
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    // } else {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    // }
  }

  void _logout(BuildContext context) async {
    // Limpar dados de autenticação ou qualquer outra coisa que você precise fazer durante o logout

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(UserData(
      fullName: '',
      email: '',
      phone: '',
      birthdate: '',
      accountType: '',
      // data_cadastro: '',
      profilePic: '',
      password: '',
      uniqueID: '',
    ));

    // Navegar de volta para a tela de login ou qualquer outra tela que você preferir
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }


  @override
  void initState() {
    super.initState();
    _checkLogin();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Container(
            child: Column(
              children: <Widget> [
                const Spacer(),
                Center(
                    child: Image.asset("assets/Ku.png", width: MediaQuery.of(context).size.width * .4,),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                      },
                      // style: EstiloApp.botaoElevado,
                      child: const Text("FAZER LOGIN")
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroPage()));
                      },
                      // style: EstiloApp.botaoElevado,
                      child: const Text("CRIAR CONTA")
                  ),
                ),

                const Spacer()
              ],
            )
        ),
      ),
    );
  }
}
