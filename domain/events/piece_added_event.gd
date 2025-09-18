extends RefCounted
class_name PieceAddedEvent

var id: int
var position: int
func _init(id_: int, position_: int) -> void  :
    id = id_
    position = position_