extends Node
class_name GameController


# Import the Piece class from domain/piece.gd
const Piece = preload("res://domain/piece.gd")
#const Domain = preload("res://domain/domain.gd")
var domain: Domain = Domain.new()

# Array to hold the state of all pieces
var pieces: Array = []

# Array to hold the scenes loaded
var scenes: Array = []

func _ready():
    DomainBus.cmd_start_game.connect(_on_start_game)

    # Initialize the pieces array with some pieces
    pieces.append(Piece.new(1, Piece.eColor.WHITE, Vector2i(0, 0)))
    pieces.append(Piece.new(2, Piece.eColor.BLACK, Vector2i(1, 0)))
    # Print all pieces' details
    for piece in pieces:
        print("Piece ", piece.id, " color: ", piece.color, " position: ", piece.position)

func _on_start_game() -> void:
    print("Starting new game...")
    domain.new_game()
    DomainBus.evt_game_started.emit()
    pass

func _on_cell_pressed(cell_position: Vector2i) -> void:
    print("Cell pressed at position: ", cell_position)
    pass

func _on_piece_pressed(piece_id: int) -> void:
    print("Piece pressed with ID: ", piece_id)
    pass

## when user pres keyboard C then open config scene
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("open_config"):   # or is_action_released/just_pressed
        var sc: ScenesController = DependencyHelper.get_instance("scenes_controller")
        if sc:
            sc.toggle_config_scene()