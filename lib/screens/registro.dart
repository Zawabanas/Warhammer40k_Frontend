import 'package:flutter/material.dart';
import 'package:login_frontend/services/auth_services.dart';
import 'package:login_frontend/providers/login_form_provider.dart';
import 'package:login_frontend/services/notifications_services.dart';
import 'package:login_frontend/ui/input_decoration.dart';
import 'package:login_frontend/widgets/card_container.dart';
import 'package:provider/provider.dart';

class RegistroPage extends StatelessWidget {
  const RegistroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          SizedBox.expand(
            child: Image.asset(
              'assets/images/fondo.png', // Asegúrate de que la ruta sea correcta
              fit: BoxFit
                  .cover, // Asegúrate de que la imagen cubra toda la pantalla
            ),
          ),
          // Contenido del registro
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 250,
                ),
                CardContainer(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Crear cuenta',
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(
                        height: 30,
                      ),
                      ChangeNotifierProvider(
                        create: (_) => Login_Provider(),
                        child: _LoginForm(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'login'),
                  style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(
                        Colors.redAccent.withOpacity(0.1),
                      ),
                      shape: WidgetStateProperty.all(const StadiumBorder())),
                  child: const Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                  hintText: 'Ejemplo@gmail.com',
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
              color: Colors.black,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      // Validar si el registro es correcto
                      final String? errorMessage = await authService.createUser(
                          loginForm.email, loginForm.password);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        // Mostrar error en pantalla
                        //NotificationsServices.showSnackbar(errorMessage);
                        NotificationsServices.showSnackbar(
                            "La contraseña debe contener almenos una mayuscula, un caracter numerico y un caracter especial !@#");
                        loginForm.isLoading = false;
                      }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Crear',
                    style: const TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
