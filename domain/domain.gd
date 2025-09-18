extends Object
class_name Domain

var board_size: Vector2i = Vector2i(8, 8)
var pieces: Array = []
var game_state: GameState = GameState.new()
var game_event_queue: DomainEventQueue = DomainEventQueue.new()
var num_pieces: int = 0

func _init() -> void:
    print("Domain initialized with board size: ", board_size)
    pass

func bump_version() -> int:
    game_state.version += 1
    print("Domain version bumped to: ", game_state.version)
    return game_state.version

func new_game() -> void:
    pieces.clear()
    print("New game started. Pieces cleared.")
    # Initialize pieces or other game state as needed
    pass    


func pause_game() -> void:
    print("Domain: Game paused !!!!!!.")
    game_state.toggle_pause()
    var event = PauseToggledEvent.new(game_state.is_paused);
    game_event_queue.enqueue(DomainEvent.new(DomainEvent.Type.PAUSE, {"state": event}, bump_version()))
    # Implement pause logic
    pass

func end_game(winner: String) -> void:
    print("Domain: Game over! Winner is: ", winner)
    var event = GameOverEvent.new(winner)
    game_event_queue.enqueue(DomainEvent.new(DomainEvent.Type.GAME_OVER, {"result": event}, bump_version()))
    # Implement end game logic

func add_piece(piece: Dictionary) -> void:
    pieces.append(piece)
    print("Piece added. Total pieces: ", pieces.size())

    var event = PieceAddedEvent.new(piece.id, piece.position)
    game_event_queue.enqueue(DomainEvent.new(DomainEvent.Type.PIECE_ADDED, {"piece": event}, bump_version()))

    pass

func add_pieces(number: int) -> void:
    for i in range(number):
        num_pieces += 1
        var piece = {"id": num_pieces, "position": 1}
        add_piece(piece)
    pass
