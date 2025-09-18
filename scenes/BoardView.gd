extends Node
class_name BoardView

var game_controller: Node = null

var children_lines: Array = []


func _ready() -> void:
    print("BoardView is ready")
    DomainBus.cmd_start_game.emit()

    # consume domain events
    DomainBus.evt_piece_added.connect(_on_piece_added)


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



func _on_piece_added(id: int, position: int) -> void:
    print("BoardView: Piece added with ID: ", id, " at position: ", position)
    # Here you can add logic to update the board view based on the new piece
