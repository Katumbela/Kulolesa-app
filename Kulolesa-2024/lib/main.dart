import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kulolesa/pages/first_steps.dart';
import 'package:kulolesa/pages/home.dart';
import 'package:kulolesa/pages/inicio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'models/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialização das notificações locais
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool primeirosPassos = prefs.getBool('primeirosPassos') ?? false; // Verifica se o onboarding já foi concluído

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(isLoggedIn: isLoggedIn, primeirosPassos: primeirosPassos), // Passa a variável primeirosPassos
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool primeirosPassos;

  const MyApp({super.key, required this.isLoggedIn, required this.primeirosPassos});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // supportedLocales: [
      //   const Locale('en'),
      //   const Locale('pt'), // Adicione o suporte para o português
      // ],
      // localizationsDelegates: [
      //   CountryLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],

      theme: ThemeData(
        fontFamily: "poppin_reg",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade700),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: primeirosPassos ? Home() : OnboardingScreen(), // Mostra a tela de onboarding se primeirosPassos for false
    );
  }
}
