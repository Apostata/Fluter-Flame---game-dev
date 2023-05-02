import 'package:get/get.dart';
import 'package:minecraft_2d/main_game.dart';

class GameReference {
  late MainGame gameReference;

  static GameReference get instance {
    return Get.put(GameReference());
  }
}
