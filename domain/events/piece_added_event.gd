extends RefCounted
class_name PieceAddedEvent

var id: int
var position: Dictionary
# TODO: types
func _init(id_: int, position_: Dictionary) -> void  :
    id = id_
    position = position_