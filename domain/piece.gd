extends Object
class_name PieceState
enum eColor { WHITE, BLACK }
var id: int
var color: eColor
var position: Vector2i
var isAlive: bool = true

func _init(_id: int, _color: eColor, _position: Vector2i) -> void:
    id = _id
    color = _color
    position = _position

