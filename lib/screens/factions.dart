import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_frontend/services/warhammer_service.dart';
import 'faction_detail_page.dart';

class FactionPage extends StatefulWidget {
  const FactionPage({super.key});

  @override
  _FactionPageState createState() => _FactionPageState();
}

class _FactionPageState extends State<FactionPage> {
  final WarhammerService warhammerService = WarhammerService();
  List<Map<String, String>> factions = [];
  int? editingFactionId;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? selectedImage;
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    loadFactions();
  }

  Future<void> loadFactions() async {
    factions = await warhammerService.fetchFactions();
    setState(() {});
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> saveChanges() async {
    if (editingFactionId != null) {
      final success = await warhammerService.editFaction(
        editingFactionId!,
        nameController.text,
        descriptionController.text,
        selectedImage,
      );

      if (success) {
        await loadFactions();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facción editada exitosamente')),
        );
        hasChanges = true;
        setState(() {
          editingFactionId = null;
          selectedImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al editar la facción')),
        );
      }
    }
  }

  Future<void> deleteFaction(int id) async {
    bool success = await warhammerService.deleteFaction(id);
    if (success) {
      await loadFactions();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facción eliminada exitosamente')),
      );
      hasChanges = true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar la facción')),
      );
    }
  }

  void startEditingFaction(int factionId, Map<String, String> faction) {
    setState(() {
      editingFactionId = factionId;
      nameController.text = faction['name'] ?? '';
      descriptionController.text = faction['description'] ?? '';
      selectedImage = null;
    });
  }

  void cancelEditing() {
    setState(() {
      editingFactionId = null;
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, hasChanges);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Facciones",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: factions.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: factions.length,
                itemBuilder: (context, index) {
                  final faction = factions[index];
                  final factionId = int.tryParse(faction['id'] ?? '');
                  final factionImage = faction['image'] ?? '';

                  return Card(
                    color: Colors.grey[850],
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          factionImage,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                      title: Text(
                        faction['name'] ?? 'Sin nombre',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        faction['description'] ?? 'Sin descripción',
                        style: const TextStyle(color: Colors.white70),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              if (factionId != null) {
                                startEditingFaction(factionId, faction);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              if (factionId != null) {
                                deleteFaction(factionId);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        bottomSheet: editingFactionId != null ? buildEditForm() : null,
      ),
    );
  }

  Widget buildEditForm() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Editar Facción',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              labelStyle: TextStyle(color: Colors.white),
            ),
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: pickImage,
            child: selectedImage != null
                ? Image.file(selectedImage!, height: 100)
                : Image.network(
                    factions.firstWhere((faction) =>
                        faction['id'] == editingFactionId.toString())['image']!,
                    height: 100,
                  ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: saveChanges,
                child: const Text('Guardar'),
              ),
              ElevatedButton(
                onPressed: cancelEditing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
