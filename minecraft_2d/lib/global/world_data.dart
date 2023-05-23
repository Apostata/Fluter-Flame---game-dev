import 'package:minecraft_2d/global/player_data.dart';
import 'package:minecraft_2d/resources/blocks.dart';
import 'package:minecraft_2d/utils/constants.dart';
import 'package:minecraft_2d/utils/game_methods.dart';

class WorldData {
  final int seed;
  WorldData({required this.seed});
  PlayerData playerData = PlayerData();

  List<List<BlocksEnum?>> rightWorldChunks = List.generate(
    chunkHeight,
    (index) => [],
  );
  List<List<BlocksEnum?>> leftWorldChunks = List.generate(
    chunkHeight,
    (index) => [],
  );

  List<int> get chunksToRender {
    final currentChunk = GameMethods.instance.currentChunk;
    return [
      currentChunk - 1,
      currentChunk,
      currentChunk + 1,
    ];
  }

  List<int> allreadyRenderedChunks = [];
}
