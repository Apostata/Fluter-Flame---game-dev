# Pre-loading Game Images
Form better game performace, lets preload all game images used until now

for this, lets create a helperFunction on `utils/preloadImages.dart`:
```dart
import 'package:flame/flame.dart';

Future<void> preloadGameImages() async {
  await Flame.images
      .load('sprite_sheets/player/player_walking_sprite_sheet.png');
  await Flame.images.load('sprite_sheets/player/player_idle_sprite_sheet.png');
  await Flame.images.load('sprite_sheets/blocks/block_sprite_sheet.png');
  await Flame.images
      .load('sprite_sheets/blocks/block_breaking_sprite_sheet.png');
}
```
then we will call this function on `main.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:minecraft_2d/layout/game_layout.dart';
import 'package:minecraft_2d/utils/preloadImages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preloadGameImages();
  runApp(const MaterialApp(
    home: GameLayout(),
    debugShowCheckedModeBanner: false,
  ));
}
```

now, lets update where they are used, for example the block_breaking_component image, at `components/block_component.dart` to get From cache instead of load:
```dart
 void initializeBlockBreakingComponent() {
    blockBreakingComponent = BlockBreakingComponent();
    blockBreakingComponent.spriteSheet = SpriteSheet(
      image: Flame.images
          .fromCache('sprite_sheets/blocks/block_breaking_sprite_sheet.png'),
      srcSize: Vector2.all(60),
    );
    blockBreakingComponent.size = GameMethods.instance.blockSizes;

    ...
  }
```