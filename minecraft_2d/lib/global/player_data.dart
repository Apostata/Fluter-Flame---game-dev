class PlayerData {
  // health
  // hunger
  // state (walking left, walking right, idle)
  ComponentMotionState componentMotionState = ComponentMotionState.idle;
}

enum ComponentMotionState {
  walkingLeft,
  walkingRight,
  idle,
  jumping,
}


/*
Current heldDown options
if(currentHeldDownOption == ComponentMotionState.wlakingLeft){
  movPlayerToLeft
}
*/