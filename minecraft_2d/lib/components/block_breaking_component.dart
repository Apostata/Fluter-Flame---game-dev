import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class BlockBreakingComponent extends SpriteAnimationComponent {
  late SpriteSheet spriteSheet;
  bool pause = false;

  @override
  void update(double dt) {
    if (!pause) {
      super.update(dt);
    }
  }
}
