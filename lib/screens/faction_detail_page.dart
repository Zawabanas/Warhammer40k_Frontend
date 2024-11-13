import 'package:flutter/material.dart';

class FactionDetailPage extends StatelessWidget {
  final Map<String, String> faction;

  const FactionDetailPage({super.key, required this.faction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(faction['name'] ?? 'Facción'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              faction['image'] ?? 'https://via.placeholder.com/150',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              faction['name'] ?? 'Nombre no disponible',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              faction['description'] ?? 'Descripción no disponible',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
