import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'チンチロアプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Random _random = Random();
  List<int?> _cpuDiceValues = [null, null, null];
  List<int?> _playerDiceValues = [null, null, null];
  String _cpuResult = '';
  String _playerResult = 'サイコロを振ってみよう！';
  String _winner = '';
  int _rollCount = 0;
  bool _gameOver = false;
  bool _isRolling = false;
  bool _playerTurnStarted = false;

  @override
  void initState() {
    super.initState();
    _playCpuTurn();
  }

  Future<void> _animateRoll(bool isPlayer) async {
    _isRolling = true;
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      setState(() {
        final roll = List.generate(3, (_) => _random.nextInt(6) + 1);
        if (isPlayer) {
          _playerDiceValues = roll;
        } else {
          _cpuDiceValues = roll;
        }
      });
    }
    _isRolling = false;
  }

  Future<void> _playCpuTurn() async {
    if (_gameOver || _isRolling) return;
    setState(() {
      _winner = '';
      _playerResult = 'サイコロを振ってみよう！';
      _playerTurnStarted = false;
    });

    for (int i = 0; i < 3; i++) {
      await _animateRoll(false);
      _cpuResult = _judgeResult(_cpuDiceValues.cast<int>());
      if (_cpuResult != '目無し') break;
    }
  }

  Future<void> _playPlayerTurn() async {
    if (_gameOver || _isRolling) return;

    setState(() {
      _playerTurnStarted = true;
    });

    await _animateRoll(true);
    _playerResult = _judgeResult(_playerDiceValues.cast<int>());
    _rollCount++;

    setState(() {
      if (_playerResult != '目無し' || _rollCount >= 3) {
        _gameOver = true;
        _decideWinner();
      }
    });
  }

  String _judgeResult(List<int> dice) {
    dice.sort();
    if (dice[0] == dice[1] && dice[1] == dice[2]) {
      if (dice[0] == 1) return 'ピンゾロ';
      return 'アラシ';
    } else if (dice[0] == dice[1] || dice[1] == dice[2]) {
      int remaining = dice[0] == dice[1] ? dice[2] : dice[0];
      return '${remaining}の目';
    } else if (dice.contains(1) && dice.contains(2) && dice.contains(3)) {
      return 'ヒフミ';
    } else if (dice.contains(4) && dice.contains(5) && dice.contains(6)) {
      return 'シゴロ';
    }
    return '目無し';
  }

  void _decideWinner() {
    final rank = [
      'ピンゾロ', 'アラシ', 'シゴロ', '6の目', '5の目', '4の目',
      '3の目', '2の目', '1の目', '目無し', 'ヒフミ'
    ];
    int cpuRank = rank.indexWhere((r) => _cpuResult.contains(r));
    int playerRank = rank.indexWhere((r) => _playerResult.contains(r));

    if (playerRank < cpuRank) {
      _winner = 'あなたの勝ち！';
    } else if (playerRank > cpuRank) {
      _winner = 'CPUの勝ち！';
    } else {
      int cpuSum = _cpuDiceValues.cast<int>().reduce((a, b) => a + b);
      int playerSum = _playerDiceValues.cast<int>().reduce((a, b) => a + b);
      if (playerSum > cpuSum) {
        _winner = 'あなたの勝ち！';
      } else if (playerSum < cpuSum) {
        _winner = 'CPUの勝ち！';
      } else {
        _winner = '引き分け！';
      }
    }
  }

  void _resetGame() {
    setState(() {
      _cpuDiceValues = [null, null, null];
      _playerDiceValues = [null, null, null];
      _cpuResult = '';
      _playerResult = 'サイコロを振ってみよう！';
      _winner = '';
      _rollCount = 0;
      _gameOver = false;
      _playerTurnStarted = false;
    });
    _playCpuTurn();
  }

  Widget _buildDice(int? value) {
    return DiceDots(value: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPlayerSection('子', _cpuDiceValues, _cpuResult),
            const Divider(height: 40, color: Colors.white),
            _buildPlayerSection('親', _playerDiceValues, _playerResult),
            const SizedBox(height: 20),
            if (_gameOver)
              Text(
                _winner,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
          ],
        ),
      ),
      floatingActionButton: _isRolling || _gameOver || !_playerTurnStarted && _cpuResult == ''
          ? null
          : _gameOver
              ? FloatingActionButton(
                  onPressed: _resetGame,
                  tooltip: 'リセット',
                  child: const Icon(Icons.refresh),
                )
              : FloatingActionButton(
                  onPressed: _playPlayerTurn,
                  tooltip: 'サイコロを振る',
                  child: const Icon(Icons.casino),
                ),
    );
  }

  Widget _buildPlayerSection(String player, List<int?> diceValues, String result) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Text(player, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: diceValues.map((value) => _buildDice(value)).toList(),
        ),
        const SizedBox(height: 20),
        Text(
          result,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

class DiceDots extends StatelessWidget {
  final int? value;
  const DiceDots({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return const SizedBox(width: 80, height: 80);
    }
    List<List<int>> dotPositions = [
      [],
      [4],
      [0, 8],
      [0, 4, 8],
      [0, 2, 6, 8],
      [0, 2, 4, 6, 8],
      [0, 2, 3, 5, 6, 8]
    ];

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 9,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: dotPositions[value!].contains(index)
                  ? (value == 1 ? Colors.red : Colors.black)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}
