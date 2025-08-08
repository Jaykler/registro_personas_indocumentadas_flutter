import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../models/persona.dart';

class DetallePersonaScreen extends StatefulWidget {
  final Persona persona;
  const DetallePersonaScreen({super.key, required this.persona});

  @override
  State<DetallePersonaScreen> createState() => _DetallePersonaScreenState();
}

class _DetallePersonaScreenState extends State<DetallePersonaScreen> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  @override
  void initState() {
    super.initState();
    _player.openPlayer();
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  void _playAudio() {
    if (widget.persona.audioPath != null) {
      _player.startPlayer(fromURI: widget.persona.audioPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalles del Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Nombre: ${widget.persona.nombre ?? 'Desconocido'}"),
            Text("Edad: ${widget.persona.edad ?? 'N/A'}"),
            Text("Nacionalidad: ${widget.persona.nacionalidad ?? 'N/A'}"),
            Text("Fecha/Hora: ${widget.persona.fechaHora}"),
            Text("Ubicación: ${widget.persona.latitud ?? ''}, ${widget.persona.longitud ?? ''}"),
            if (widget.persona.descripcion != null) Text("Descripción: ${widget.persona.descripcion}"),
            const SizedBox(height: 10),
            if (widget.persona.fotoPath != null)
              Image.file(File(widget.persona.fotoPath!), height: 200),
            const SizedBox(height: 10),
            if (widget.persona.audioPath != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text("Reproducir Nota de Voz"),
                onPressed: _playAudio,
              )
          ],
        ),
      ),
    );
  }
}
