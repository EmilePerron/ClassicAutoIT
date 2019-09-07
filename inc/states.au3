; Defines the different states the character can be in
Global Const $STATE_STOPPED = -1;
Global Const $STATE_BREAK = 0;
Global Const $STATE_IDLE = 1;
Global Const $STATE_FIGHT = 2;
Global Const $STATE_REGEN = 3;
Global Const $STATE_DEAD = 4;
Global Const $STATE_POST_FIGHT = 5;
Global Const $STATE_SEARCH = 6;
Global Const $STATE_HERB = 6;

; Global state variable
Local $_state = $STATE_STOPPED

; Setters and getters for the global state
Func setState($newState)
   $_state = $newState
   updateStateLabel()
EndFunc

Func getState()
   Return $_state
EndFunc
