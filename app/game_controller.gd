extends Node
class_name GameController
var max_ms_per_frame := 2.0  

# Import the Piece class from domain/piece.gd
const Piece = preload("res://domain/piece.gd")
var domain: Domain = Domain.new()
var previous_queue_size: int = 0

# Array to hold the scenes loaded
var scenes: Array = []

# Controllers
var scenes_controller: ScenesController = null

signal game_state_changed(new_state:GameControllerState);

# Total time elapsed since the game started
var total_time: float = 0.0
var previous_time: float = 0.0
var ellapsed_time: float = 0.0

var handlers = {
    DomainEvent.Type.PAUSE: PauseEventHandler.handle,
    DomainEvent.Type.GAME_OVER: GameOverEventHandler.handle,
    DomainEvent.Type.PIECE_ADDED: PieceAddedEventHandler.handle,
    DomainEvent.Type.PIECES_ADDED: PiecesAddedEventHandler.handle
    # Add more event types and their handlers as needed
}

func _ready():
    # Initialize the childs controllers
    scenes_controller = DependencyHelper.get_instance("scenes_controller") as ScenesController


func _process(_delta: float) -> void:
    total_time += _delta
    previous_time = total_time
    ellapsed_time += _delta
    if ellapsed_time >= 1.0:
        domain.add_piece({"id": -1, "position": {"x": randi() % 1000, "y": randi() % 500}})            
        ellapsed_time = 0.0


    var start := Time.get_ticks_usec()
    while not domain.game_event_queue.is_empty():
        consume_domain_event()  # must be fast / scene-tree-safe
        if (Time.get_ticks_usec() - start) >= int(max_ms_per_frame * 1000.0):
            break


func map_domain_state_to_app_state() -> GameControllerState:
    var game_state = domain.game_state
    var app_state = GameControllerState.new()
    app_state.num_pieces = game_state.num_pieces
    app_state.current_turn = game_state.current_turn
    app_state.score = game_state.score.duplicate()
    app_state.is_game_over = game_state.is_game_over
    app_state.is_paused = game_state.is_paused
    app_state.version = game_state.version
    return app_state


func consume_domain_event() -> void:
    # TODO: Make thread safe. var event = domain.game_event_queue.try_dequeue()
    var event = domain.game_event_queue.dequeue()
    if event == null:
        return
    if event.type in handlers:
        handlers[event.type].call(event)
        game_state_changed.emit(map_domain_state_to_app_state())
    else:
        print("Unknown event in game controller:", event.type)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("open_config"):   
            scenes_controller.open_config_scene()
    if event.is_action_pressed("open_main"):
            scenes_controller.open_main_menu()
    if event.is_action_pressed("pause_game"):
        domain.pause_game()
    if event.is_action_pressed("game_over"):
        domain.end_game("Player 1")  # Example winner name
    if event.is_action_pressed("add_pieces"):
        print ("DEBUG: Adding a pieces...")
        # domain.add_pieces_async(10000)
        # domain.add_pieces(100000)
        domain.add_pieces_2(10)
        print ("DEBUG: Pieces added.")
    if event.is_action_pressed("add_piece"):
        print ("DEBUG: Adding a piece...")
        domain.add_piece({"id": -1, "position": {"x": randi() % 1000, "y": randi() % 1000}})
        print ("DEBUG: Piece added.")
    pass


