import 'package:flutter/foundation.dart';

class PlayerScore {
  String name;
  Map<String, int> rounds = {};

  PlayerScore(this.name);
}

class GameState extends ChangeNotifier {
  List<PlayerScore> players = [];
  int currentRoundIndex = 0;
  bool gameStarted = false;

  final List<String> rounds = [
    '1 Corrida/1 Tercia',
    '2 Corridas',
    '2 Tercias',
    '2 Corridas/1 Tercia',
    '2 Tercias/1 Corrida',
    '3 Corridas',
    '3 Tercias',
  ];

  bool get isGameFinished => currentRoundIndex >= rounds.length;

  void addPlayer(String name) {
    players.add(PlayerScore(name));
    notifyListeners();
  }

  void startGame() {
    gameStarted = true;
    notifyListeners();
  }

  void addScores(Map<String, int> scores) {
    if (isGameFinished) return;

    for (var player in players) {
      player.rounds[rounds[currentRoundIndex]] = scores[player.name] ?? 0;
    }

    currentRoundIndex =
        (currentRoundIndex < rounds.length - 1)
            ? currentRoundIndex + 1
            : rounds.length; // Fuerza el estado de juego terminado

    notifyListeners();
  }

  void resetGame() {
    players.clear();
    currentRoundIndex = 0;
    gameStarted = false;
    notifyListeners();
  }

  Map<String, int> getTotalScores() {
    Map<String, int> totals = {};
    for (var player in players) {
      totals[player.name] = player.rounds.values.fold(0, (a, b) => a + b);
    }
    return totals;
  }
}
