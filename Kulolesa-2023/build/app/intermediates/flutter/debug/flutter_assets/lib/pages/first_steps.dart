

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _onboardingPages = [
    OnboardingPage(
      img: "assets/app.json",
      title: "Bem-vindo à Kulolesa!",
      description: "Explore o maximo que a kulolesa pode lhe oferecer",
    ),
    OnboardingPage(
      img: "assets/carServ.json",
      title: "Serviços de Transportes ",
      description: "Encontre transportes que vão para onde deseja ir, ganhe dinheiro com o seu transporte",
    ),
    OnboardingPage(
      img: "assets/acom.json",
      title: "Encontre Acomodações",
      description: "Encontre acomodações em qualquer parte de África, ou ganhe dinheiro com o seu espaço.",
    ),
    OnboardingPage(
      img: "assets/acts.json",
      title: "Encontre Experiências",
      description: "Encontre experiências, activdades em toda a parte do mundo,ganhe dinheiro com o seus serviços.",
    ),
    OnboardingPage(
      img: "assets/start.json",
      title: "Vamos Começar!",
      description: "Comece por criar sua conta e usufruir da Kulolesa.",
    ),
  ];

  void _onNextPressed() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('primeirosPassos', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _onboardingPages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return _onboardingPages[index];
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(""),
            ElevatedButton(
              onPressed: _onNextPressed,
              child: Text(
                _currentPage < _onboardingPages.length - 1 ? "Próximo" : "Concluir",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String img;
  final String title;
  final String description;

  const OnboardingPage({
    required this.img,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(img, height: 350, width: 250,),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              description, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}