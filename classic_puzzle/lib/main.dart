import 'package:classic_puzzle/view/game_home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classic Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameHomeView(tilesCount: 4,),
    );
  }
}

