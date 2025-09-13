extends Node

# Import the Piece class from domain/piece.gd
const Piece = preload("res://domain/piece.gd")

# Array to hold the state of all pieces
var pieces: Array = []


func _ready():
	# Initialize the pieces array with some pieces
	pieces.append(Piece.new(1, Piece.eColor.WHITE, Vector2i(0, 0)))
	pieces.append(Piece.new(2, Piece.eColor.BLACK, Vector2i(1, 0)))
	# Print all pieces' details
	for piece in pieces:
		print("Piece ", piece.id, " color: ", piece.color, " position: ", piece.position)
	# Open the board scene
	_open_board_scene()        
	
func _on_cell_pressed(cell_position: Vector2i) -> void:
	print("Cell pressed at position: ", cell_position)
	pass

func _on_piece_pressed(piece_id: int) -> void:
	print("Piece pressed with ID: ", piece_id)
	pass

func _open_board_scene() -> void:
	var board_scene: PackedScene = preload("res://scenes/BoardView.tscn")
	var board_instance = board_scene.instantiate()   # <- abans era instance()
	add_child(board_instance)
	print("Board scene opened and connected.")




## func _process(delta: float) -> void:
##     print("Updating game state...", delta)
##     pass    
