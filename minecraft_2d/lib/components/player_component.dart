import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/global/player_data.dart';

class Player extends SpriteAnimationComponent {
  static const double _speed = 5;
  static bool _isFacingRight = true;
  @override
  Future<void> onLoad() async {
    super.onLoad();

    SpriteSheet playSpriteSheet = SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/player/player_walking_sprite_sheet.png'),
      // srcSize: Vector2(60, 60),
      srcSize: Vector2.all(60),
    );

    animation = playSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
    );
    position = Vector2(100, 500);
    size = Vector2(100, 100);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final gameWalkingReference = GameReference
        .instance.gameReference.worldData.playerData.componentMotionState;

    move(gameWalkingReference);
  }

  move(ComponentMotionState gameWalkingReference) {
    // Moving Left
    if (gameWalkingReference == ComponentMotionState.walkingLeft) {
      position.x -= _speed;
      if (_isFacingRight) {
        flipHorizontallyAroundCenter();
        _isFacingRight = false;
      }
    }

    // Moving right
    if (gameWalkingReference == ComponentMotionState.walkingRight) {
      position.x += _speed;
      if (!_isFacingRight) {
        flipHorizontallyAroundCenter();
        _isFacingRight = true;
      }
    }
  }
}
