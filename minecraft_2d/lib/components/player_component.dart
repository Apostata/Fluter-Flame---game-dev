import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft_2d/global/game_reference.dart';
import 'package:minecraft_2d/global/player_data.dart';
import 'package:minecraft_2d/utils/game_methods.dart';

class Player extends SpriteAnimationComponent with CollisionCallbacks {
  static bool _isFacingRight = true;
  static final Vector2 _playerDimensions = Vector2.all(60);
  static const _stepTimeIdle = 0.4;
  static const double _stepTimeWalking = 0.1;
  double yVelocity = 0;
  bool isCollidingBottom = false;
  bool isCollidingLeft = false;
  bool isCollidingRight = false;
  double jumpForce = 0;

  late SpriteSheet playerWalkingSpriteSheet;
  late SpriteSheet playerIdleSpriteSheet;

  late SpriteAnimation playerWalkingAnimation = playerWalkingSpriteSheet
      .createAnimation(row: 0, stepTime: _stepTimeWalking);

  late SpriteAnimation playerIdleAnimation =
      playerIdleSpriteSheet.createAnimation(row: 0, stepTime: _stepTimeIdle);

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    final double playersFootposition = position.y - size.y * 0.3;

    for (var intersectionPoint in intersectionPoints) {
      bool difBettwenXMoreThen40PercentPlayerWidth =
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              size.x * 0.4;

      if ((intersectionPoint.y > playersFootposition) &&
          difBettwenXMoreThen40PercentPlayerWidth) {
        // gravity collision
        isCollidingBottom = true;
        yVelocity = 0;
      }

      if (intersectionPoint.y < playersFootposition) {
        if (intersectionPoint.x > position.x) {
          //right collision
          isCollidingRight = true;
        } else {
          //left collision
          isCollidingLeft = true;
        }
      }
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    playerWalkingSpriteSheet = SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/player/player_walking_sprite_sheet.png'),
      srcSize: _playerDimensions,
    );

    playerIdleSpriteSheet = SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/player/player_idle_sprite_sheet.png'),
      srcSize: _playerDimensions,
    );
    priority = 2;
    anchor = Anchor.bottomCenter;
    size = GameMethods.instance.blockSizes * 1.5;
    animation = playerIdleAnimation;
    position = Vector2(GameMethods.instance.getScreenSize().width * .1,
        GameMethods.instance.getScreenSize().height * .1);

    add(RectangleHitbox());
  }

  void fallingLogic(double dt) {
    final double gravity = GameMethods.instance.gravity;
    final double frameGravity = gravity * dt;
    if (!isCollidingBottom) {
      if (yVelocity < frameGravity * 5) {
        // to cam follow the player
        position.y += yVelocity;
        yVelocity += frameGravity;
      } else {
        position.y += yVelocity;
      }
    }
  }

  void resetCollinsions() {
    isCollidingBottom = false;
    isCollidingLeft = false;
    isCollidingRight = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final gameWalkingReference = GameReference
        .instance.gameReference.worldData.playerData.componentMotionState;
    moveLogic(gameWalkingReference, dt);
    fallingLogic(dt);
    resetCollinsions();

    if (jumpForce > 0) {
      position.y -= jumpForce;
      // jumpForce -= GameMethods.instance.gravity * dt;
      jumpForce -= GameMethods.instance.blockSizes.y * 0.15;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    size = GameMethods.instance.blockSizes * 1.5;
  }

  void move(ComponentMotionState componentMotionState, double dt) {
    final double speed = (GameMethods.instance.speed * dt);
    switch (componentMotionState) {
      case ComponentMotionState.walkingLeft:
        if (!isCollidingLeft) {
          position.x -= speed;
          if (_isFacingRight) {
            flipHorizontallyAroundCenter();
            _isFacingRight = false;
          }
          animation = playerWalkingAnimation;
        }
        break;
      case ComponentMotionState.walkingRight:
        if (!isCollidingRight) {
          position.x += speed;
          if (!_isFacingRight) {
            flipHorizontallyAroundCenter();
            _isFacingRight = true;
          }
          animation = playerWalkingAnimation;
        }
        break;
      default:
        break;
    }
  }

  void moveLogic(ComponentMotionState gameWalkingReference, double dt) {
    // Moving Left
    if (gameWalkingReference == ComponentMotionState.walkingLeft) {
      move(ComponentMotionState.walkingLeft, dt);
    }
    // Moving right
    if (gameWalkingReference == ComponentMotionState.walkingRight) {
      move(ComponentMotionState.walkingRight, dt);
    }
    // Idle
    if (gameWalkingReference == ComponentMotionState.idle) {
      animation = playerIdleAnimation;
    }
    if (gameWalkingReference == ComponentMotionState.jumping) {
      // if (isCollidingBottom) {
      jumpForce = (GameMethods.instance.blockSizes.y * 0.6);
      // }
    }
  }
}
