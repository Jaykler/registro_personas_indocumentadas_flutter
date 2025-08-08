import 'package:flutter/material.dart';

class AcercaScreen extends StatelessWidget {
  const AcercaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Acerca de")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/agente.png"),
            ),
            const SizedBox(height: 10),
            const Text("Nombre: Juan Pérez", style: TextStyle(fontSize: 18)),
            const Text("Matrícula: 20241234", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const Text(
              "“Proteger nuestras fronteras es proteger nuestro futuro”",
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
