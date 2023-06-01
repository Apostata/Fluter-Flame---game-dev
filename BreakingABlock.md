# Breaking the blocks
Now lets make the player break the blocks.

Firts, we need to create a component `components/block_breaking_component.dart`: 
```dart
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

```
**Note: this update method is optional, in my case I want to pause the breaking animantion, if we stop breaking a block, so we can return to break again the block from where we stoped**

and then, at the `components/block_component.dart` we wil add the `Tappable` mixing on it, add a `blockBreakingComponent` property, update the onLoad method, create `initializeBlockBreakingComponent` to initialize the `BlockBreakingComponent` and add some tappable methods:
```dart
class BlockComponent extends SpriteComponent with Tappable {
	...
	late BlockBreakingComponent blockBreakingComponent;

	...
	 @override
	FutureOr<void> onLoad() async {
		super.onLoad();
		size = GameMethods.instance.blockSizes;
		sprite = await GameMethods.instance.getSpriteFromBlock(block);
		add(RectangleHitbox());
		initializeBlockBreakingComponent(); //added this
	}

  ...
  void initializeBlockBreakingComponent() async {
    blockBreakingComponent = BlockBreakingComponent();
    blockBreakingComponent.spriteSheet = SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/blocks/block_breaking_sprite_sheet.png'),
      srcSize: Vector2.all(60),
    );
    blockBreakingComponent.size = GameMethods.instance.blockSizes;

    blockBreakingComponent.animation =
        blockBreakingComponent.spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.3,
      loop: false,
    );
    blockBreakingComponent.animation?.onComplete = () {
      remove(blockBreakingComponent); //remove the blockBreaking component
      removeFromParent(); // remove the block from game
      GameMethods.instance.replaceBlockAtWorldChunk(null, blockIndex);// remove the block from the worldChunk
    };
  }

  ...
   @override
  bool onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    if (!blockBreakingComponent.pause) {
      add(blockBreakingComponent);
    }
    blockBreakingComponent.pause = false; //unpause animation at the BlockBreakingComponent
    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    blockBreakingComponent.pause = true; //pause animation at the BlockBreakingComponent
    return true;
  }

  @override
  bool onTapCancel() {
    blockBreakingComponent.pause = true; //pause animation at the BlockBreakingComponent
    return true;
  }
}
```

## Add BlockData
To put some default properties to the blocks we will create a  `BlockData` class at `resources/blocks.dart`

```dart
enum BlocksEnum {
  ...
}
...
class BlockData {
  final bool isCollidable;
  final double baseMiningSpeed;
  final bool breakable;

  BlockData({
    required this.isCollidable,
    required this.baseMiningSpeed,
    this.breakable = true,
  });

  factory BlockData.getBlockDataForBlock(BlocksEnum block) {
    switch (block) {
      case BlocksEnum.cactus:
      case BlocksEnum.deadBush:
      case BlocksEnum.grassPlant:
      case BlocksEnum.redFlower:
      case BlocksEnum.purpleFlower:
      case BlocksEnum.drippingWhiteFlower:
      case BlocksEnum.yellowFlower:
      case BlocksEnum.whiteFlower:
        return blockDataMap['plant']!;
      case BlocksEnum.stone:
      case BlocksEnum.cobblestone:
      case BlocksEnum.coalOre:
      case BlocksEnum.ironOre:
      case BlocksEnum.diamondOre:
      case BlocksEnum.goldOre:
        return blockDataMap['stone']!;
      case BlocksEnum.grass:
      case BlocksEnum.dirt:
      case BlocksEnum.sand:
        return blockDataMap['soil']!;
      case BlocksEnum.birchPlank:
      case BlocksEnum.craftingTable:
        return blockDataMap['woodPlank']!;
      case BlocksEnum.birchLog:
        return blockDataMap['wood']!;
      case BlocksEnum.birchLeaf:
        return blockDataMap['leaf']!;
      default:
        return blockDataMap['unbreakable']!;
    }
  }
}

final blockDataMap = {
  'soil': BlockData(
    isCollidable: true,
    baseMiningSpeed: 0.5,
  ),
  'wood': BlockData(
    isCollidable: false,
    baseMiningSpeed: 3,
  ),
  'plant': BlockData(
    isCollidable: false,
    baseMiningSpeed: 0.01,
  ),
  'leaf': BlockData(
    isCollidable: false,
    baseMiningSpeed: 0.3,
  ),
  'stone': BlockData(
    isCollidable: true,
    baseMiningSpeed: 4,
  ),
  'woodPlank': BlockData(
    isCollidable: true,
    baseMiningSpeed: 2.5,
  ),
  'unbreakable': BlockData(
    isCollidable: true,
    baseMiningSpeed: 0,
    breakable: false,
  ),
};
```

now we can check if a block belongs to a group of blocks, and get some default properties for it, like isBreakable, isCollidable, baseMiningSpeed. Then update the `initializeBlockBreakingComponent` method at `components/block_component.dart` to check if the block is breakable, isCollidable your mining speed.
```dart
class BlockComponent extends SpriteComponent with Tappable {
  ...
  void initializeBlockBreakingComponent() async {
      blockBreakingComponent = BlockBreakingComponent();
      blockBreakingComponent.spriteSheet = SpriteSheet(
        image: await Flame.images
            .load('sprite_sheets/blocks/block_breaking_sprite_sheet.png'),
        srcSize: Vector2.all(60),
      );
      blockBreakingComponent.size = GameMethods.instance.blockSizes;

      blockBreakingComponent.animation =
          blockBreakingComponent.spriteSheet.createAnimation(
        row: 0,
        stepTime: BlockData.getBlockDataForBlock(block).baseMiningSpeed / 6, // six is the number of sprites in the animantion
        loop: false,
      );
      blockBreakingComponent.animation?.onComplete = () {
        remove(blockBreakingComponent);
        removeFromParent();
        GameMethods.instance.replaceBlockAtWorldChunk(null, blockIndex);
      };
  }
}
```


$\Leftarrow$ [Back](README.md) 