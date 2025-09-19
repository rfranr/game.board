extends Object
class_name Domain

var board_size: Vector2i = Vector2i(8, 8)
var pieces: Array = []
var game_state: GameState = GameState.new()
var game_event_queue: DomainEventQueue = DomainEventQueue.new()

func _init() -> void:
    print("Domain initialized with board size: ", board_size)
    pass

func bump_version() -> int:
    game_state.version += 1
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
    game_state.num_pieces += 1

    var event = PieceAddedEvent.new(piece.id, piece.position)
    game_event_queue.enqueue(DomainEvent.new(DomainEvent.Type.PIECE_ADDED, {"piece": event}, bump_version()))

    pass

## func add_pieces(number: int) -> void:
##     print("Debug: Domain: Adding ", number, " pieces...")
##     for i in range(number):
##         game_state.num_pieces += 1
##         var _x = randi() % 1000   # % board_size.x
##         var _y = randi() % 1000   # % board_size.y
##         var piece = {"id": game_state.num_pieces, "position": {"x": _x, "y": _y}}
##         add_piece(piece)
## 
##         # some delay to simulate long processing
##         OS.delay_msec(1)
##     print("Debug: Domain: Finished adding ", number, " pieces.")
##     pass

func add_pieces_2(number: int) -> void:
    print("Debug: Domain: Adding ", number, " pieces...")
    var _pieces: Array[Dictionary] = []
    for i in range(number):
        game_state.num_pieces += 1
        var _x = randi() % 1000   # % board_size.x
        var _y = randi() % 1000   # % board_size.y
        var piece = {"id": game_state.num_pieces, "position": {"x": _x, "y": _y}}
        _pieces.append(piece)
    print("Debug: Domain: Finished adding ", number, " pieces.")
    pass
    for piece in _pieces:
        pieces.append(piece)

    var event = PiecesAddedEvent.new(_pieces)
    game_event_queue.enqueue(DomainEvent.new(DomainEvent.Type.PIECES_ADDED, {"pieces": event}, bump_version()))
    print("Debug: Domain: Finished adding ", number, " pieces.")
    pass




##func add_pieces_async(number: int) -> void:
##    
##    # This is a placeholder for asynchronous piece addition logic
##    var thread = Thread.new()
##    thread.start(func() : add_pieces(number));
##    #await thread.wait_to_finish()
##    #thread.free()
##    pass

