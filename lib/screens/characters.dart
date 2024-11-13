import 'package:flutter/material.dart';
import 'package:login_frontend/services/warhammer_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final WarhammerService warhammerService = WarhammerService();
  List<Map<String, String>> characters = [];

  @override
  void initState() {
    super.initState();
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    characters = await warhammerService.fetchCharacters();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personajes"),
        backgroundColor: Colors.black,
      ),
      body: characters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: characters[index]['image']!,
                    width: 50,
                    height: 50,
                    placeholder: (context, url) =>
                        Image.network('https://via.placeholder.com/150'),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                  title: Text(characters[index]['name']!),
                  subtitle: Text(characters[index]['faction'] ?? ''),
                );
              },
            ),
    );
  }
}
