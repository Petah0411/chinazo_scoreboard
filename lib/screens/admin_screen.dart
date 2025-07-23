import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<TextEditingController> _controllers = [];
  final _playerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final gameState = context.read<GameState>();
    _controllers.clear();
    for (var _ in gameState.players) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final totals = gameState.getTotalScores();

    if (gameState.isGameFinished) {
      final minScore = totals.values.reduce((a, b) => a < b ? a : b);
      final winners = totals.entries.where((e) => e.value == minScore).toList();

      return Scaffold(
        appBar: AppBar(title: const Text('🎉¡Juego Terminado!🎉')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🏆 RESULTADO FINAL 🏆',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                ...totals.entries.map(
                  (e) => ListTile(
                    title: Text(e.key, style: const TextStyle(fontSize: 18)),
                    trailing: Text(
                      e.value.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'GANADOR',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ...winners.map(
                        (w) => Text(
                          '${w.key} - ${w.value} puntos',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => context.read<GameState>().resetGame(),
                  child: const Text(
                    'NUEVO JUEGO',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentRound = gameState.rounds[gameState.currentRoundIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(gameState.gameStarted ? currentRound : 'Agregar Jugadores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!gameState.gameStarted) ...[
              TextField(
                controller: _playerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Del Jugador',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_playerNameController.text.trim().isNotEmpty) {
                    gameState.addPlayer(_playerNameController.text.trim());
                    _playerNameController.clear();
                    _initializeControllers();
                  }
                },
                child: const Text('Agregar Jugador'),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children:
                    gameState.players
                        .map(
                          (player) => Chip(
                            label: Text(player.name),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () {
                              gameState.players.remove(player);
                              _initializeControllers();
                            },
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed:
                    gameState.players.isEmpty
                        ? null
                        : () => gameState.startGame(),
                child: const Text('♦️COMENZAR JUEGO❤️'),
              ),
            ] else ...[
              Text(
                'RONDA ${gameState.currentRoundIndex + 1} DE ${gameState.rounds.length}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: gameState.players.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              gameState.players[index].name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: _controllers[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Puntos',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final scores = {
                    for (int i = 0; i < gameState.players.length; i++)
                      gameState.players[i].name:
                          int.tryParse(_controllers[i].text) ?? 0,
                  };
                  gameState.addScores(scores);
                  _initializeControllers();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'GUARDAR RONDA 💾',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'PUNTAJES ACTUALES:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 105, 172),
                      ),
                    ),
                    ...totals.entries.map(
                      (e) => ListTile(
                        title: Text(e.key),
                        trailing: Text(e.value.toString()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
