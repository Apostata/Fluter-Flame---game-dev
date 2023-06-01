import 'package:flame/flame.dart';

Future<void> preloadGameImages() async {
  await Flame.images
      .load('sprite_sheets/player/player_walking_sprite_sheet.png');
  await Flame.images.load('sprite_sheets/player/player_idle_sprite_sheet.png');
  await Flame.images.load('sprite_sheets/blocks/block_sprite_sheet.png');
  await Flame.images
      .load('sprite_sheets/blocks/block_breaking_sprite_sheet.png');
}
