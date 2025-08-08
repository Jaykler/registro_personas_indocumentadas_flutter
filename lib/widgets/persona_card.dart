import 'dart:io';
import 'package:flutter/material.dart';
import '../models/persona.dart';

class PersonaCard extends StatelessWidget {
  final Persona persona;
  final VoidCallback? onTap;

  const PersonaCard({
    super.key,
    required this.persona,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: persona.fotoPath != null
            ? CircleAvatar(
                backgroundImage: FileImage(File(persona.fotoPath!)),
                radius: 25,
              )
            : const CircleAvatar(
                radius: 25,
                child: Icon(Icons.person),
              ),
        title: Text(
          persona.nombre ?? 'Desconocido',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (persona.edad != null) Text('Edad: ${persona.edad}'),
            if (persona.nacionalidad != null && persona.nacionalidad!.isNotEmpty)
              Text('Nacionalidad: ${persona.nacionalidad}'),
            if (persona.descripcion != null && persona.descripcion!.isNotEmpty)
              Text(
                persona.descripcion!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
