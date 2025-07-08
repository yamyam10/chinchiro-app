import 'package:flutter/material.dart';

class FriendMatchPage extends StatelessWidget {
  const FriendMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('友達と対戦'),
      ),
      body: const Center(
        child: Text(
          '友達と対戦モード\n（ここにゲームロジックを追加）',
          style: TextStyle(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
