import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../db/database_helper.dart';
import '../models/persona.dart';

class AddPersonaScreen extends StatefulWidget {
  const AddPersonaScreen({super.key});

  @override
  State<AddPersonaScreen> createState() => _AddPersonaScreenState();
}

class _AddPersonaScreenState extends State<AddPersonaScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _nacionalidadController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  double? lat;
  double? lng;
  String? direccion;

  File? fotoFile;
  String? audioPath;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> _obtenerUbicacion() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });

    List<Placemark> placemarks = await placemarkFromCoordinates(lat!, lng!);
    if (placemarks.isNotEmpty) {
      setState(() {
        direccion =
            "${placemarks.first.locality}, ${placemarks.first.country}";
      });
    }
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        fotoFile = File(picked.path);
      });
    }
  }

  Future<void> _toggleRecord() async {
    if (_isRecording) {
      final result = await _recorder.stopRecorder();
      setState(() {
        audioPath = result;
        _isRecording = false;
      });
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder.startRecorder(toFile: path);
      setState(() {
        audioPath = path;
        _isRecording = true;
      });
    }
  }

  Future<void> _guardar() async {
    String fecha = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
    Persona nueva = Persona(
      nombre: _nombreController.text,
      edad: int.tryParse(_edadController.text),
      nacionalidad: _nacionalidadController.text,
      fechaHora: fecha,
      latitud: lat,
      longitud: lng,
      descripcion: _descripcionController.text,
      fotoPath: fotoFile?.path,
      audioPath: audioPath,
    );

    await DatabaseHelper().insertPersona(nueva);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Registro")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nombreController, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: _edadController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Edad estimada")),
            TextField(controller: _nacionalidadController, decoration: const InputDecoration(labelText: "Nacionalidad")),
            TextField(controller: _descripcionController, maxLines: 3, decoration: const InputDecoration(labelText: "Descripción")),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Obtener Ubicación"),
              onPressed: _obtenerUbicacion,
            ),
            if (lat != null) Text("Lat: $lat, Lng: $lng"),
            if (direccion != null) Text("Dirección: $direccion"),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Tomar Foto"),
              onPressed: _tomarFoto,
            ),
            if (fotoFile != null)
              Image.file(fotoFile!, height: 150),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? "Detener Grabación" : "Grabar Nota de Voz"),
              onPressed: _toggleRecord,
              style: ElevatedButton.styleFrom(backgroundColor: _isRecording ? Colors.red : Colors.blue),
            ),
            if (audioPath != null) Text("Audio guardado"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardar,
              child: const Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}
