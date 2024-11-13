import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:login_frontend/screens/create_faction_page.dart';
import 'package:login_frontend/services/warhammer_service.dart';
import 'package:login_frontend/screens/factions.dart';
import 'package:login_frontend/screens/faction_detail_page.dart'; // Importar la página de detalles

class PrincipalScr extends StatefulWidget {
  const PrincipalScr({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<PrincipalScr> {
  final WarhammerService warhammerService = WarhammerService();
  List<Map<String, String>> factions = [];
  List<Map<String, String>> characters = [];
  List<Map<String, String>> units = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    factions = await warhammerService.fetchFactions();
    characters = await warhammerService.fetchCharacters();
    units = await warhammerService.fetchUnits();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warhammer 40K Universe',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text("Nombre de Usuario"),
              accountEmail: const Text("email@ejemplo.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              decoration: BoxDecoration(color: Colors.grey[900]),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Facciones'),
              onTap: () async {
                Navigator.pop(context);
                bool? hasChanged = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FactionPage()),
                );

                if (hasChanged == true) {
                  await loadData();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('Personajes'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.military_tech),
              title: const Text('Unidades'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Crear Facción'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateFactionPage()),
                ).then((updated) {
                  if (updated == true) {
                    loadData();
                  }
                });
              },
            ),
          ],
        ),
      ),
      body: factions.isEmpty && characters.isEmpty && units.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Facciones',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(height: 200, autoPlay: true),
                      items: factions.map((faction) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FactionDetailPage(
                                      faction: faction,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.transparent,
                                child: Stack(
                                  children: [
                                    Image.network(
                                      faction['image']!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error,
                                                  color: Colors.red),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Text(
                                        faction['name']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Personajes Destacados',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: characters.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      characters[index]['image'] ?? '',
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error,
                                                  color: Colors.red),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  characters[index]['name']!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Unidades Principales',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: units.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      units[index]['image'] ?? '',
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error,
                                                  color: Colors.red),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  units[index]['name']!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
