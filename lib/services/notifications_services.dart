import 'package:flutter/material.dart';

class NotificationsServices {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      duration: const Duration(seconds: 2), // Duración del Snackbar
      backgroundColor: Colors.redAccent, // Color de fondo
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
