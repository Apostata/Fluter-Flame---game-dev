import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/global/player_data.dart';

class ControllerButtonWidget extends StatefulWidget {
  final String path;
  final VoidCallback onTap;

  const ControllerButtonWidget(
      {super.key, required this.path, required this.onTap});

  @override
  State<ControllerButtonWidget> createState() => _ControllerButtonWidgetState();
}

class _ControllerButtonWidgetState extends State<ControllerButtonWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // GameReference.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
          widget.onTap();
        },
        onTapUp: (_) {
          setState(() {
            isPressed = false;
            Get.find<GameReference>()
                .gameReference
                .worldData
                .playerData
                .componentMotionState = ComponentMotionState.idle;
          });
        },
        child: Opacity(
          opacity: isPressed ? 0.5 : 0.8,
          child: SizedBox(
            height: screenSize.height / 17,
            width: screenSize.width / 17,
            child: Image.asset('assets/controller/${widget.path}'),
          ),
        ),
      ),
    );
  }
}
