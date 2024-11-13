import 'package:flutter/material.dart';
import 'package:login_frontend/services/warhammer_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});

  @override
  _UnitsPageState createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  final WarhammerService warhammerService = WarhammerService();
  List<Map<String, String>> units = [];

  @override
  void initState() {
    super.initState();
    loadUnits();
  }

  Future<void> loadUnits() async {
    units = await warhammerService.fetchUnits();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unidades"),
        backgroundColor: Colors.black,
      ),
      body: units.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: units.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: units[index]['image']!,
                    width: 50,
                    height: 50,
                    placeholder: (context, url) =>
                        Image.network('https://via.placeholder.com/150'),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                  title: Text(units[index]['name']!),
                  subtitle: Text(units[index]['type'] ?? ''),
                );
              },
            ),
    );
  }
}
