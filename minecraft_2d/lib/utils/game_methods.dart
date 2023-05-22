import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/utils/constants.dart';

class GameMethods {
  static late Size _gameScreenSize;

  static GameMethods get instance {
    return GameMethods();
  }

  set gameScreenSize(BuildContext context) {
    _gameScreenSize = MediaQuery.of(context).size;
  }

  Vector2 get blockSizes {
    // return Vector2.all(getScreenSize().width / chunkWidth);
    return Vector2.all(30);
  }

  Size getScreenSize() {
    // ignore: deprecated_member_use
    // print(WidgetsBinding.instance.window.physicalSize.width);
    // return MediaQueryData.fromWindow(WidgetsBinding.instance.window)
    //     .size; // deprecated
    return _gameScreenSize;
  }

  int get notGroundArea {
    return (chunkHeight * 0.2).toInt();
  }

  int get maxSecondarySoilHeight {
    return notGroundArea + 6;
  }

  Future<SpriteSheet> getBlockSpriteSheet() async {
    return SpriteSheet(
      image: await Flame.images.load(
        'sprite_sheets/blocks/block_sprite_sheet.png',
      ),
      srcSize: Vector2.all(
        60,
      ),
    );
  }

  Future<Sprite> getSpriteFromBlock(BlocksEnum block) async {
    SpriteSheet spriteSheet = await getBlockSpriteSheet();
    return spriteSheet.getSprite(0, block.index);
  }
  // get the sprite with the given enumblock passed
}
