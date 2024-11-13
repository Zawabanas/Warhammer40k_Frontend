import 'package:flutter/material.dart';
import 'package:login_frontend/services/auth_services.dart';
import 'package:login_frontend/services/notifications_services.dart';
import 'package:login_frontend/screens/checking.dart';
import 'package:login_frontend/screens/login.dart';
import 'package:login_frontend/screens/principal.dart';
import 'package:login_frontend/screens/registro.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warhammer40K',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 247, 230, 196)),
        useMaterial3: true,
      ),
      initialRoute: 'checking',
      routes: {
        'login': (_) => const LoginPage(),
        'register': (_) => const RegistroPage(),
        'home': (_) => const PrincipalScr(),
        'checking': (_) => const CheckAuthScreen(),
      },
      scaffoldMessengerKey: NotificationsServices.messengerKey,
    );
  }
}
