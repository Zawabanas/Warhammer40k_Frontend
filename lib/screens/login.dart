import 'package:flutter/material.dart';
import 'package:login_frontend/services/auth_services.dart';
import 'package:login_frontend/services/notifications_services.dart';
import 'package:login_frontend/ui/input_decoration.dart';
import 'package:login_frontend/widgets/card_container.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        // Ocupa todo el espacio disponible
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned.fill(
              child: Image.asset(
                'assets/images/fondo.png',
                fit: BoxFit
                    .cover, // Ajusta la imagen para cubrir toda la pantalla
              ),
            ),
            // Contenido del login
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 250),
                        CardContainer(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text('Bienvenido',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                              const SizedBox(height: 30),
                              ChangeNotifierProvider(
                                create: (_) => Login_Provider(),
                                child: _LoginForm(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, 'register'),
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 243, 222, 222)
                                  .withOpacity(0.1),
                            ),
                            shape:
                                WidgetStateProperty.all(const StadiumBorder()),
                          ),
                          child: const Text(
                            'Crear una nueva cuenta',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<Login_Provider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: const Color.fromARGB(255, 33, 6, 6),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        // TODO: validar si el login es correcto
                        final String? errorMessage = await authService.login(
                            loginForm.email, loginForm.password);

                        if (errorMessage == null) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          // print( errorMessage );
                          //NotificationsServices.showSnackbar(errorMessage);
                          NotificationsServices.showSnackbar(
                              "Credenciales inválidas");
                          loginForm.isLoading = false;
                        }
                      },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Espere' : 'Ingresar',
                      style: const TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }
}
