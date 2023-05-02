import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_2d/global/world_data.dart';
import 'package:minecraft_2d/main_game.dart';
import 'package:minecraft_2d/widgets/controller_widget.dart';

class GameLayout extends StatelessWidget {
  const GameLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //the game logic
        GameWidget(game: MainGame(worldData: WorldData())),
        //HUDs
        const ControllerWidget()
      ],
    );
  }
}
