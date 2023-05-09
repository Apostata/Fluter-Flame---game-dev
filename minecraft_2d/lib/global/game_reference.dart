import 'package:get/get.dart';
import 'package:minecraft_2d/main_game.dart';

class GameReference {
  late MainGame gameReference;

  // static GameReference get instance {
  //   // não entendi muito bem mas parece que sempre coloca e pega uma referência de si na memória
  //   return Get.put(GameReference());
  // }

  static GameReference get instance {
    return Get.find<GameReference>();
  }
}
