extends RefCounted
class_name GameControllerState

enum State {
    PLAYING,
    PAUSED,
    GAME_OVER
}

var current_state: State = State.PLAYING
var previous_queue_size: int = 0
var num_pieces: int = 0
var current_turn: int = 0
var score: Dictionary = {"player1": 0, "player2": 0}
var is_game_over: bool = false
var is_paused: bool = false
var version: int = 0
