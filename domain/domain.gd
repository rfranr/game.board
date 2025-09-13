extends Object
class_name Domain
var board_size: Vector2i = Vector2i(8, 8)
var pieces: Array = []

func _init() -> void:
    print("Domain initialized with board size: ", board_size)
    pass

func new_game() -> void:
    pieces.clear()
    print("New game started. Pieces cleared.")
    # Initialize pieces or other game state as needed
    pass    