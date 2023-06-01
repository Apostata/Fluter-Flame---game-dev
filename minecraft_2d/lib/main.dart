import 'package:flutter/material.dart';
import 'package:minecraft_2d/layout/game_layout.dart';
import 'package:minecraft_2d/utils/preloadImages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preloadGameImages();
  runApp(const MaterialApp(
    home: GameLayout(),
    debugShowCheckedModeBanner: false,
  ));
}
