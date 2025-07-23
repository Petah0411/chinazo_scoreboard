class Round {
  final int corridas;
  final int tercias;

  Round({required this.corridas, required this.tercias});

  // Calcula el puntaje (ajusta los valores según las reglas de tu juego)
  int calculateScore() {
    return corridas * 10 + tercias * 5; // Ejemplo: corrida=10pts, tercia=5pts
  }

  // Convierte los datos a un formato compatible con Firebase
  Map<String, dynamic> toMap() {
    return {
      'corridas': corridas,
      'tercias': tercias,
      'score': calculateScore(),
    };
  }
}
