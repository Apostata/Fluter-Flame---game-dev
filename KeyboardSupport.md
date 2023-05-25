# Add keyboard support
To add keyboard controls to the game we need to add a Mixing to the game class, so we can use the keyboard events, at `main_game.dart` add the Mixing `HasKeyboardHandlerComponents` to the game class. and them create a method  `onKeyEvent` to handle the keyboard events.

```dart
class MainGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
	...
	@override
	KeyEventResult onKeyEvent(
		RawKeyEvent event,
		Set<LogicalKeyboardKey> keysPressed,
	) {
		super.onKeyEvent(event, keysPressed);

		// move player to right
		if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
			keysPressed.contains(LogicalKeyboardKey.keyD)) {
		GameReference.instance.gameReference.worldData.playerData
			.componentMotionState = ComponentMotionState.walkingRight;
		}

		// move player to left
		if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
			keysPressed.contains(LogicalKeyboardKey.keyA)) {
		GameReference.instance.gameReference.worldData.playerData
			.componentMotionState = ComponentMotionState.walkingLeft;
		}

		// jump
		if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
			keysPressed.contains(LogicalKeyboardKey.keyW) ||
			keysPressed.contains(LogicalKeyboardKey.space)) {
		worldData.playerData.componentMotionState = ComponentMotionState.jumping;
		}

		if (keysPressed.isEmpty) {
			worldData.playerData.componentMotionState = ComponentMotionState.idle;
		}

		return KeyEventResult.ignored;
	}
}

```

the `keysPressed.isEmpty` if statement will set the player to idle state when no key is pressed, to avoid infinity movement.
$\leftarrow$ [Back](README.md)