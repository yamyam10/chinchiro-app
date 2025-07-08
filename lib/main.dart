import 'package:flutter/material.dart';
import 'game.dart'; // 練習モード画面
import 'friend_match.dart'; // 友達と対戦画面
import 'online_match.dart'; // 全国対戦画面
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'チンチロ Online',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // 英語
        const Locale('ja', ''), // 日本語
      ],
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 66, 66, 66),
        primaryColor: Colors.blueAccent,
        colorScheme: ColorScheme.dark().copyWith(
          secondary: Colors.amber,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'チンチロ Online',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Noto Serif',
              ),
            ),
            const SizedBox(height: 40),

            // 練習ボタン
            _buildButton(context, 'CPUと対戦', const MyHomePage(title: 'CPUと対戦')),

            const SizedBox(height: 20),

            // 友達と対戦ボタン
            _buildButton(context, '友達と対戦', const FriendMatchPage()),

            const SizedBox(height: 20),

            // 全国対戦ボタン
            _buildButton(context, '全国対戦', const OnlineMatchPage()),
          ],
        ),
      ),
    );
  }

  // ボタンウィジェットを共通化
  Widget _buildButton(BuildContext context, String text, Widget page) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: const Color.fromARGB(255, 66, 66, 66),
          side: const BorderSide(color: Colors.white, width: 2),
          textStyle: const TextStyle(fontSize: 20),
          foregroundColor: Colors.white,
        ),
        child: Text(text),
      ),
    );
  }
}
