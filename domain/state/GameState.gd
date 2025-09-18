extends RefCounted
class_name GameState

signal is_paused_changed(new_value: bool)

var current_turn: int = 0
var score: Dictionary = {"player1": 0, "player2": 0}
var is_game_over: bool = false
var is_paused: bool = false
var version: int = 0

func _init() -> void:
    pass

func set_is_paused(value: bool) -> void:
    if is_paused != value:
        is_paused = value
        emit_signal("is_paused_changed", is_paused)

func toggle_pause() -> void:
    set_is_paused(!is_paused)