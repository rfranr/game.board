extends Node
class_name BoardView

var game_controller: Node = null

var children_lines: Array = []

## signal cell_pressed(cell_position: Vector2i)
## signal piece_pressed(piece_id: int) 

func _ready() -> void:
    print("BoardView is ready")
    DomainBus.cmd_start_game.emit()

    # get child Line2D nodes and print their names
    for child in get_children():
        if child is Line2D:
            print("Found Line2D child: ", child.name)
            children_lines.append(child)

    pass # Replace with function body.


func _process(delta: float) -> void:
    for line in children_lines:
        line.rotation += delta  # Rotate each line slightly each frame
        line.width = 2 + 2 * abs(sin(delta / 1000.0))  # Vary width over time

    pass # Replace with function body.

