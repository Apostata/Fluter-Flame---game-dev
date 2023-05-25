# Gravity and collisions
 
## Gravity
 Firt, we need to add a gravity speed at `/utils/constants.dart`
 
 ```dart
const int chunkWidth = 16;
const int chunkHeight = 25;

const int gravity = 9;

 ```

Now we need to update the `update` method in the player component to add the gravity speed at `/components/player.dart`

```dart
class Player extends SpriteAnimationComponent{
	....

	@override
	void update(double dt) {
		super.update(dt);
		final gameWalkingReference = GameReference
			.instance.gameReference.worldData.playerData.componentMotionState;
		move(gameWalkingReference);

		//gravity
		position.y += yVelocity;
		yVelocity += gravity;
		
	}
}

```
At this point the player will fall indefinitely, so we need to add a collision detection to stop the player from falling.


## Collision
We need to add a collision detection to the game, so we can check if the player is colliding with a block or not, for this, at `main_game.dart` we will add a Mixing on the FlameGame class to detect collisions.

```dart
class MainGame extends FlameGame with HasCollisionDetection{
	...
}
```

add the Mixing `CollisionCallbacks` to Player Component and the method `onCollision` to handle the collision, and add the HitBoxes at onLoad method. to set The dimensions of the player's to interact with others blocks.

```dart
class Player extends SpriteAnimationComponent with CollisionCallbacks {
	...

  @override
  Future<void> onLoad() async {
	...
	add(RectangleHitbox());

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    print('Other is $other');
    print('intersectionPoints is $intersectionPoints');
  }
}
```

Now we need to add the HitBoxes to the blocks, so we can detect the collision with the player, at `/components/block.dart` add the HitBox to the Block Component.

```dart

@override
class BlockComponent extends SpriteComponent {
  FutureOr<void> onLoad() async {
	...
	add(RectangleHitbox());
  }
}
```

### Collision detection for gravity and walking
Now we need to add the collision detection to the game, so we can check if the player is colliding with a block or not, for this we will add some logic to walking.
the gravity and walking speed will be base in block size.

at `/utils/game_methods.dart` class, we will add 2 getters, one for gravity and other for speed:

```dart
class GameMethods {
	...
	double get gravity {
    return (0.8 * blockSizes.y);
  }

  double get speed {
    return (3 * blockSizes.x);
  }
}
```

so now lets update `components/player.dart` to add the collision detection to the player.
lets update some methods:

```dart
class Player extends SpriteAnimationComponent with CollisionCallbacks {
	...

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    final double playersFootposition = position.y - size.y * 0.3; //30% of player size

    for (var intersectionPoint in intersectionPoints) {
      bool difBettwenXMoreThen40PercentPlayerWidth =
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              size.x * 0.4; //this will define tha only if more than 40% of player size is colliding.

      if ((intersectionPoint.y > playersFootposition) &&
          difBettwenXMoreThen40PercentPlayerWidth) {
        isCollidingBottom = true;
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
  void update(double dt) {//dt = framerate
    super.update(dt);
    final gameWalkingReference = GameReference
        .instance.gameReference.worldData.playerData.componentMotionState;
    moveLogic(gameWalkingReference, dt);
    fallingLogic(dt);
    resetCollinsions();
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
  }

  void move(ComponentMotionState componentMotionState, double dt) {
    final double speed = (GameMethods.instance.speed * dt);
    switch (componentMotionState) {
      case ComponentMotionState.walkingLeft:
        if (!isCollidingLeft) { //not colliding left
          position.x -= speed;
          if (_isFacingRight) {
            flipHorizontallyAroundCenter();
            _isFacingRight = false;
          }
          animation = playerWalkingAnimation;
        }
        break;
      case ComponentMotionState.walkingRight:
        if (!isCollidingRight) { // not colliding right
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
}
```

### Add jumping movement

Now we need to add the jumping movement to the player.
firts wee need to update playerData class to add the jumping state `/global/player_data.dart`

```dart
class PlayerData {
  
  ComponentMotionState componentMotionState = ComponentMotionState.idle;
}

enum ComponentMotionState {
  walkingLeft,
  walkingRight,
  idle,
  jumping, //jumping state
}
```

now at the `widgets/controller_widget.dart` add the state to the button:
```dart
class ControllerWidget extends StatelessWidget {
  const ControllerWidget({super.key});
 
  @override
  Widget build(BuildContext context) {
    final playerData =
        GameReference.instance.gameReference.worldData.playerData;

    return Positioned(
     ...
      child: Row(
        children: [
          ...
          ControllerButtonWidget(
            path: 'center_button.png',
            onTap: () {
              playerData.componentMotionState = ComponentMotionState.jumping;
            },
          ),
         ...
        ],
      ),
    );
  }
}
```
a last thing to do is update the `components/player.dart` to add the jumping logic:

```dart
class Player extends SpriteAnimationComponent with CollisionCallbacks {
	...
	double jumpForce = 0;

	...
	void moveLogic(ComponentMotionState gameWalkingReference, double dt) {
    	...
		if (gameWalkingReference == ComponentMotionState.jumping) {
			jumpForce = (GameMethods.instance.blockSizes.y * 0.6);
		}
  	}
	...
}
```


$\leftarrow$ [Back](README.md)