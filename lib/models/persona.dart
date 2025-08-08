class Persona {
  int? id;
  String? nombre;
  int? edad;
  String? nacionalidad;
  String fechaHora;
  double? latitud;
  double? longitud;
  String? descripcion;
  String? fotoPath;
  String? audioPath;

  Persona({
    this.id,
    this.nombre,
    this.edad,
    this.nacionalidad,
    required this.fechaHora,
    this.latitud,
    this.longitud,
    this.descripcion,
    this.fotoPath,
    this.audioPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
      'nacionalidad': nacionalidad,
      'fechaHora': fechaHora,
      'latitud': latitud,
      'longitud': longitud,
      'descripcion': descripcion,
      'fotoPath': fotoPath,
      'audioPath': audioPath,
    };
  }

  factory Persona.fromMap(Map<String, dynamic> map) {
    return Persona(
      id: map['id'],
      nombre: map['nombre'],
      edad: map['edad'],
      nacionalidad: map['nacionalidad'],
      fechaHora: map['fechaHora'],
      latitud: map['latitud'],
      longitud: map['longitud'],
      descripcion: map['descripcion'],
      fotoPath: map['fotoPath'],
      audioPath: map['audioPath'],
    );
  }
}
