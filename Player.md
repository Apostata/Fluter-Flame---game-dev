
# Player
## Creating the player
For the player creation we will use some components from Flame library
```dart
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    SpriteSheet playSpriteSheet = SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/player/player_walking_sprite_sheet.png'),
      srcSize: Vector2.all(60),
    );

    animation = playSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
    );
    size = Vector2(100, 100);
  }
  ...
}
```

the `SpriteAnimationComponent` is a component that animates a `SpriteSheet`

first we need to create an `onLoad` function that will define the sprite sheet used and its dimensions

An SpriteSheet is a grided image with diferents positions for the player to be animated.

![image](minecraft_2d/assets/images/sprite_sheets/player/player_idle_sprite_sheet.png)  

in the animation property of the load function of the `SpriteAnimationComponent` we must define the dimension of the grid (60px in the case) and the row, that is the row in the grided image.
then we create a `update` functions that will control the possition of the player on screen in a update

### Making player walk
Now we will need 2 animations, one for walking and another for idle at the player SpriteAnimationComponent
```dart
...

class Player extends SpriteAnimationComponent {
  static const double _speed = 3;
  static bool _isFacingRight = true;
  static final Vector2 _playerDimensions = Vector2.all(60);
  static const _stepTimeIdle = 0.4;
  static const double _stepTimeWalking = 0.1;

  late SpriteSheet playerWalkingSpriteSheet;
  late SpriteSheet playerIdleSpriteSheet;

  late SpriteAnimation playerWalkingAnimation = playerWalkingSpriteSheet
      .createAnimation(row: 0, stepTime: _stepTimeWalking);

  late SpriteAnimation playerIdleAnimation =
      playerIdleSpriteSheet.createAnimation(row: 0, stepTime: _stepTimeIdle);

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
    anchor = Anchor.center;
    size = Vector2(100, 100);
    animation = playerIdleAnimation;
    position = Vector2(GameMethods.instance.getScreenSize().width * .1,
        GameMethods.instance.getScreenSize().height * .7);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final gameWalkingReference = GameReference
        .instance.gameReference.worldData.playerData.componentMotionState;

    move(gameWalkingReference);
  }

  ...

  move(ComponentMotionState gameWalkingReference) {
    // Moving Left
    if (gameWalkingReference == ComponentMotionState.walkingLeft) {
      position.x -= _speed;
      if (_isFacingRight) {
        flipHorizontallyAroundCenter();
        _isFacingRight = false;
      }
      animation = playerWalkingAnimation;
    }

    // Moving right
    if (gameWalkingReference == ComponentMotionState.walkingRight) {
      position.x += _speed;
      if (!_isFacingRight) {
        flipHorizontallyAroundCenter();
        _isFacingRight = true;
      }
      animation = playerWalkingAnimation;
    }

    // Idle
    if (gameWalkingReference == ComponentMotionState.idle) {
      animation = playerIdleAnimation;
    }
  }
}

```

### Make the player responsive too
```dart
class Player extends SpriteAnimationComponent {
  ...

  @override
  Future<void> onLoad() async {
    super.onLoad();
   ...
    size = GameMethods.instance.blockSizes * 1.5;
    ...
  }

...

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    size = GameMethods.instance.blockSizes * 1.5;
  }

  ...
}

```

### Adjusting the movment speed accordly to frame rate and reset at every one second(to smooth the movent)
At players component:

```dart
class Player extends SpriteAnimationComponent with CollisionCallbacks {
  double localPlayerSpeed = 0;
  bool refreshSpeed = false;

  ...
    @override
  Future<void> onLoad() async {
    super.onLoad();
    ...
    add(
      TimerComponent(
        period: 1,
        repeat: true,
        onTick: () {
          refreshSpeed = true;
        },
      ),
    );
  }

  ...
  @override
  void update(double dt) {
    super.update(dt);
    ...
    ajustFpsPlayerSpeed(dt);
    resetCollinsions();
  }


  ...
  void ajustFpsPlayerSpeed(double dt) {
    if (refreshSpeed) {
      localPlayerSpeed = (GameMethods.instance.speed * dt);
      refreshSpeed = false;
    }
  }
}
```


$\leftarrow$ [Back](README.md)