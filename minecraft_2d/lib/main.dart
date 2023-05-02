import 'package:flutter/material.dart';
import 'package:minecraft_2d/layout/game_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: GameLayout(),
    debugShowCheckedModeBanner: false,
  ));
}
