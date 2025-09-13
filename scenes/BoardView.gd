extends Node
class_name BoardView

var game_controller: Node = null


## signal cell_pressed(cell_position: Vector2i)
## signal piece_pressed(piece_id: int) 

func _ready() -> void:
    print("BoardView is ready")
    AppBus.cmd_start_game.emit()
    pass # Replace with function body.




