import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = "http://warhammer40k.somee.com";
  //final String _baseUrl = 'http://127.0.0.1:5276';

  final storage = const FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'Password': password
    };

    final url = Uri.parse('$_baseUrl/api/Cuentas/registrar');

    final resp = await http.post(
      url,
      headers: {
        "Content-Type": "application/json-patch+json", // Ajuste en Content-Type
        "accept": "text/plain" // Según lo que se muestra en tu curl
      },
      body: json.encode(authData),
    );

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('token')) {
      await storage.write(key: 'token', value: decodeResp['token']);
      return null;
    } else {
      print(decodeResp);
      return decodeResp['error'];
    }
    return null;
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };
    final url = Uri.parse('$_baseUrl/api/Cuentas/Login');

    final resp = await http.post(
      url,
      headers: {
        "Content-Type": "application/json-patch+json", // Ajuste en Content-Type
        "accept": "text/plain" // Según lo que se muestra en tu curl
      },
      body: json.encode(authData),
    );

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('token')) {
      await storage.write(key: "token", value: decodeResp["token"]);
      return null;
    } else {
      return decodeResp["error"];
    }
  }

  Future logout() async {
    await storage.delete(key: "token");
  }

  Future<String> readToken() async {
    return await storage.read(key: "token") ?? '';
  }
}
