import 'package:flutter/material.dart';

class OnlineMatchPage extends StatelessWidget {
  const OnlineMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('全国対戦'),
      ),
      body: const Center(
        child: Text(
          '全国対戦モード\n（ここにオンライン機能を実装）',
          style: TextStyle(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
