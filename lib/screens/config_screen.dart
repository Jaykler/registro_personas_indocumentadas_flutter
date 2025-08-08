import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../db/database_helper.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  Future<void> _borrarTodo(BuildContext context) async {
    await DatabaseHelper().deleteAll();
    Directory appDir = await getApplicationDocumentsDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Todos los datos fueron eliminados")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración")),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.delete_forever),
          label: const Text("Borrar Todo"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => _borrarTodo(context),
        ),
      ),
    );
  }
}
