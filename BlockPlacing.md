# Block placinng
Placing a block based on tapped or clicked position.

Firt we need to create some methods, one to get the block position from the click position and another to get the chunk index from the block position and another one to replace a block in chunk, in `utils/game_methods.dart` :

```dart
class GameMethods {
	...
  Vector2 getIndexPositionFromPixels(Vector2 clickposition) {
    final double x = (clickposition.x / blockSizes.x).floorToDouble();
    final double y = (clickposition.y / blockSizes.y).floorToDouble();
    return Vector2(x, y);
  }

  int getChunkIndexFromPositionIndex(Vector2 positionIndex) {
    return (positionIndex.x ~/ chunkWidth) + (positionIndex.x < 0 ? -1 : 0);
  }
}

...
void replaceBlockAtWorldChunk(BlocksEnum? block, Vector2 blockIndex) {
    //verify if the block is in the left or right world chunk
    WorldData worldData = GameReference.instance.gameReference.worldData;

    if (blockIndex.x > 0) {
      worldData.rightWorldChunks[blockIndex.y.toInt()][blockIndex.x.toInt()] =
          block;
    } else {
      worldData.leftWorldChunks[blockIndex.y.toInt()]
          [blockIndex.x.toInt().abs() - 1] = block;
    }
  }
```
then in `main_game.dart` we will add a `HasTappable` mixing a onTapDown method :

```dart
class MainGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, HasTappables {
  ...

  void blockPlacingLogic(Vector2 placingPosition) {
    final gameMethods = GameMethods.instance;

    if (placingPosition.y > 0 && placingPosition.y < chunkHeight) {
      gameMethods.replaceBlockAtWorldChunk(BlocksEnum.dirt, placingPosition);
      add(BlockComponent(
        block: BlocksEnum.dirt,
        blockIndex: placingPosition,
        chunkIdx: gameMethods.getChunkIndexFromPositionIndex(placingPosition),
      ));
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    final gameMethods = GameMethods.instance;
    Vector2 placingPosition =
        gameMethods.getIndexPositionFromPixels(info.eventPosition.game);
    blockPlacingLogic(placingPosition);
    super.onTapDown(pointerId, info);
  }
}
```

## Place block in player range 
in `utils/connstants.dart` we will add some constants to define the player range to place blocks and the chunk size :

```dart
...
const int maxBlockPlacingReach = 3;
```


at `utils/game_methods.dart` we will add a method to get te clicked/tapperd positition relative to player and another to check if the block is in the player range :
```dart
class GameMethods {
	...
List<int> getXAndYTappedpositionRelativeToPlayer(Vector2 tappedPosition) {
    double pointy0 = playerYposition.floor() - tappedPosition.y;
    double pointx0 = playerXposition.floor() - tappedPosition.x;
    int x = pointx0.toInt().abs();
    int y = (pointy0 - 1).toInt().abs();
    return [x, y];
  }

  bool isPlacingPositionInPLayerRange(Vector2 positionIndex) {
    final relativePositionToPlayer =
        getXAndYTappedpositionRelativeToPlayer(positionIndex);

    bool xInReach = relativePositionToPlayer[0] <= maxBlockPlacingReach;
    bool yInReach = relativePositionToPlayer[1] <= maxBlockPlacingReach;
    if (xInReach && yInReach) {
      return true;
    }
    return false;
  }
}
```

### Place block only where are no BlocksEnum (withing player range)

```dart
class GameMethods {
	...
 BlocksEnum? getBlockAtPosition(Vector2 postionIndex) {
    WorldData worldData = GameReference.instance.gameReference.worldData;
    if (postionIndex.x > 0 &&
        worldData.rightWorldChunks.length <= postionIndex.y.toInt() &&
        worldData.rightWorldChunks[postionIndex.y.toInt()].length <=
            postionIndex.y.toInt()) {
      return worldData.rightWorldChunks[postionIndex.y.toInt()]
          [postionIndex.x.toInt()];
    }
    if (postionIndex.x > 0 &&
        worldData.leftWorldChunks.length <= postionIndex.y.toInt() &&
        worldData.rightWorldChunks[postionIndex.y.toInt()].length <=
            postionIndex.x.toInt().abs() - 1) {
      return worldData.leftWorldChunks[postionIndex.y.toInt()]
          [postionIndex.x.toInt().abs() - 1];
    }
    return null;
  }
}
```

#### Place blocks Adjacent to others (withing player range and where aren't a block)

```dart
class GameMethods {
	...
bool areThereAdjacentBlocks(Vector2 positionIndex) {
    List<bool> thereAreAcjacentBlocks = [false, false, false, false];
    final isThereBlockAbove =
        getBlockAtPosition(Vector2(positionIndex.x, positionIndex.y - 1));
    final isThereBlockBelow =
        getBlockAtPosition(Vector2(positionIndex.x, positionIndex.y + 1));
    final isThereBlockLeft =
        getBlockAtPosition(Vector2(positionIndex.x - 1, positionIndex.y));
    final isThereBlockRight =
        getBlockAtPosition(Vector2(positionIndex.x + 1, positionIndex.y));
    thereAreAcjacentBlocks[0] = isThereBlockAbove != null;
    thereAreAcjacentBlocks[1] = isThereBlockBelow != null;
    thereAreAcjacentBlocks[2] = isThereBlockRight != null;
    thereAreAcjacentBlocks[3] = isThereBlockLeft != null;

    return thereAreAcjacentBlocks.contains(true);
  }
}
```

ant finaly at `main_game.dart` we will add the logic to place blocks only where there are no blocks, adjacent to others  and not in the same position as the player, changing the onTapDown method to this :

```dart
class MainGame extends FlameGame{
	...
	void blockPlacingLogic(Vector2 placingPosition) {
    final gameMethods = GameMethods.instance;

    final bool isIsPlayerRange =
        gameMethods.isPlacingPositionInPLayerRange(placingPosition);

    final bool isNullBlock =
        gameMethods.getBlockAtPosition(placingPosition) == null;

    final bool areThereAdjacentBlocks =
        gameMethods.areThereAdjacentBlocks(placingPosition);

    final List<int> xAndYRelativeToPlayer =
        gameMethods.getXAndYTappedpositionRelativeToPlayer(placingPosition);
    final bool sameBlockAsPlayer =
        xAndYRelativeToPlayer[0] == 0 && xAndYRelativeToPlayer[1] == 0;

    if (placingPosition.y > 0 &&
        placingPosition.y < chunkHeight &&
        isIsPlayerRange &&
        isNullBlock &&
        areThereAdjacentBlocks &&
        !sameBlockAsPlayer) {
      gameMethods.replaceBlockAtWorldChunk(BlocksEnum.dirt, placingPosition);
      add(BlockComponent(
        block: BlocksEnum.dirt,
        blockIndex: placingPosition,
        chunkIdx: gameMethods.getChunkIndexFromPositionIndex(placingPosition),
      ));
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    final gameMethods = GameMethods.instance;
    Vector2 placingPosition =
        gameMethods.getIndexPositionFromPixels(info.eventPosition.game);
    blockPlacingLogic(placingPosition);
    super.onTapDown(pointerId, info);
  }
}
```
$\Leftarrow$ [Back](README.md) 