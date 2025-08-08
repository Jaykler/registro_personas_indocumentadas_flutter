import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/persona.dart';
import 'add_persona_screen.dart';
import 'detalle_persona_screen.dart';
import 'acerca_screen.dart';
import 'config_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Persona> personas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    personas = await DatabaseHelper().getPersonas();
    setState(() {});
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registros de Migración"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AcercaScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ConfigScreen())),
          ),
        ],
      ),
      body: personas.isEmpty
          ? const Center(child: Text("No hay registros"))
          : ListView.builder(
              itemCount: personas.length,
              itemBuilder: (context, index) {
                final p = personas[index];
                return ListTile(
                  title: Text(p.nombre ?? "Desconocido"),
                  subtitle: Text(p.fechaHora),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetallePersonaScreen(persona: p),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddPersonaScreen()));
          _loadData();
        },
      ),
    );
  }
}
