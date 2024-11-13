import 'package:flutter/material.dart';
import 'package:login_frontend/services/auth_services.dart';
import 'package:login_frontend/screens/login.dart';
import 'package:login_frontend/screens/principal.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return const Text('');
            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoginPage(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            } else {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const PrincipalScr(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
