extends RefCounted
class_name DomainEvent

enum Type { PAUSE, RESUME, GAME_OVER, PIECE_ADDED, PIECES_ADDED }

var type: Type
var payload: Dictionary
var version: int = 0
func _init(t: Type, p: Dictionary = {}, v: int = 0) -> void:
    type = t
    payload = p
    version = v
