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



$\Leftarrow$ [Back](README.md) 