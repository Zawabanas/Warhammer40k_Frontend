import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class WarhammerService {
  //final String baseUrl = 'https://127.0.0.1:5276';
  final String baseUrl = 'http://warhammer40k.somee.com';

  // Método para crear una nueva facción
  Future<bool> createFaction(
      String name, String description, File? image) async {
    final uri = Uri.parse('$baseUrl/api/factions');
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['description'] = description;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final response = await request.send();
    return response.statusCode == 200;
  }

  // Método para obtener la lista de facciones, incluyendo 'description'
  Future<List<Map<String, String>>> fetchFactions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/factions'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        return data.map((faction) {
          return {
            'id': faction['id'].toString(),
            'name': faction['name'].toString(),
            'image': '$baseUrl${faction['imagen'].toString()}',
            'description': faction['description']?.toString() ??
                'Descripción no disponible',
          };
        }).toList();
      } else {
        throw Exception('Error al obtener las facciones');
      }
    } catch (e) {
      print('Error en fetchFactions: $e');
      return [];
    }
  }

  // edtitar faccion
  Future<bool> editFaction(
      int id, String name, String description, File? image) async {
    final uri = Uri.parse('$baseUrl/api/factions/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..fields['name'] = name
      ..fields['description'] = description;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final response = await request.send();
    return response.statusCode == 200;
  }

  //metodo para borrar faccion
  Future<bool> deleteFaction(int id) async {
    final url = Uri.parse('$baseUrl/api/factions/$id');
    try {
      final response = await http.delete(url);
      print('Respuesta del servidor: ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en deleteFaction: $e');
      return false;
    }
  }

  // Método para obtener la lista de personajes
  Future<List<Map<String, String>>> fetchCharacters() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/Characters'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        return data.map((character) {
          return {
            'name': character['name'].toString(),
            'image': '$baseUrl${character['imagen'].toString()}',
          };
        }).toList();
      } else {
        throw Exception('Error al obtener personajes');
      }
    } catch (e) {
      print('Error en fetchCharacters: $e');
      return [];
    }
  }

  // Método para obtener la lista de unidades
  Future<List<Map<String, String>>> fetchUnits() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/Units'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        return data.map((unit) {
          return {
            'name': unit['name'].toString(),
            'image': '$baseUrl${unit['imagen'].toString()}',
          };
        }).toList();
      } else {
        throw Exception('Error al obtener las unidades');
      }
    } catch (e) {
      print('Error en fetchUnits: $e');
      return [];
    }
  }
}
