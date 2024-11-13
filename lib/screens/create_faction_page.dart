import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_frontend/services/warhammer_service.dart';

class CreateFactionPage extends StatefulWidget {
  const CreateFactionPage({super.key});

  @override
  _CreateFactionPageState createState() => _CreateFactionPageState();
}

class _CreateFactionPageState extends State<CreateFactionPage> {
  final WarhammerService warhammerService = WarhammerService();
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? description;
  File? image;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> createFaction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final success =
            await warhammerService.createFaction(name!, description!, image);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Facción creada con éxito")));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error al crear la facción")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Nueva Facción"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Nombre de la Facción"),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
                onSaved: (value) => name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Descripción"),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
                onSaved: (value) => description = value,
              ),
              const SizedBox(height: 10),
              image == null
                  ? const Text("No se ha seleccionado ninguna imagen")
                  : Image.file(image!, height: 100),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Seleccionar Imagen"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: createFaction,
                child: const Text("Crear Facción"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
