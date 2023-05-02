# Flutter + Flame course
We will build a 2d Minecraft

## Flutter commands to remember
Create a new project :`flutter create {PROJECT_NAME}` 
Add a package: `flutter pub add {PACKAGE_NAME}`


## Creating first Flame widget
In this project we will use the [Flame Engine](https://flame-engine.org/) to create a Minecraft 2d version

first we create a `MainGame` instance in `main-game.dart`:
```dart
import 'package:flame/game.dart';

class MainGame extends FlameGame {}

```

then, in `main.dart` we must ensure that flutter binds are initialized (normal when use a external lib at the begining of the projetc like this):
```dart
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_2d/main-game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GameWidget(game: MainGame()));
}
```

## Create the game
Accordly to de [Game Design document](GameDesign.md):
we should change `main.dart` to :
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: GameLayout(),
    debugShowCheckedModeBanner: false,
  ));
}
```
create a `GameLayout Widget`:
```dart
...

class GameLayout extends StatelessWidget {
  const GameLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //the game logic
        GameWidget(game: MainGame()),
        //HUDs
        const ControllerWidget() 
      ],
    );
  }
}

```
### Creating the ControllerWidget
Theres is not diferente here from a normal Fluter app.
Just create a statefull Widget as placeholder e manager of buttons actions for the buttons and another widget with the buttons

### Creating the player
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
      // srcSize: Vector2(60, 60),
      srcSize: Vector2.all(60),
    );

    animation = playSpriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
    );
    size = Vector2(100, 100);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += 1;
    position.y += 1;
  }
}

```

the `SpriteAnimationComponent` is a component that animates a `SpriteSheet`

first we need to create an `onLoad` function that will define the sprite sheet used and its dimensions

An SpriteSheet is a grided image with diferents positions for the player to be animated.

![image](assets/images/sprite_sheets/player/player_idle_sprite_sheet.png)  

in the animation property of the load function of the `SpriteAnimationComponent` we must define the dimension of the grid (60px in the case) and the row, that is the row in the grided image.
then we create a `update` functions that will control the possition of the player on screen in a update

### World data
We will Create a instance of the world the player will be inserted to pass to the `MainGame`
create a file called `world_data.dart` with the `WorldData` class:

```dart
class WorldData {}

```

then create a instance  of the `WorldData` in `GameLayout` passing to `MainGame`:
```dart
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
```
so, update `MainGame` to recieve `WorldData`
```dart 
class MainGame extends FlameGame {
  final WorldData worldData;
  GameReference globalGameReference = Get.put(GameReference());
  Player playerComponent = Player();

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(playerComponent);
    Get.put(MainGame(worldData: worldData));
  }
}
``` 

## Create and store a reference for the hole game


**NOTES:**
**This tutotial is from Create a Minecraft game with Flutter + Flame ministred by [Aadhi Arun](https://github.com/AirAdmirer) in [Udemy](https://www.udemy.com/) platform**

**This resume is only for study, all content an intelectual property is from the author [Aadhi Arun](https://github.com/AirAdmirer)**