extends Node
class_name GameController

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

var handlers = {
    DomainEvent.Type.PAUSE: PauseEventHandler.handle,
    DomainEvent.Type.GAME_OVER: GameOverEventHandler.handle,
    DomainEvent.Type.PIECE_ADDED: PieceAddedEventHandler.handle,
    # Add more event types and their handlers as needed
}

func _ready():
    # Initialize the childs controllers
    scenes_controller = DependencyHelper.get_instance("scenes_controller") as ScenesController


func _process(delta: float) -> void:
    var current_queue_size = domain.game_event_queue.size()
    var batch_size = 5
    if current_queue_size != previous_queue_size:
        print("GameController: Domain event queue size changed from ", previous_queue_size, " to ", current_queue_size)
        var queue_delta = current_queue_size - previous_queue_size
        batch_size = int(float(queue_delta) / 10.0) + 10
        previous_queue_size = current_queue_size

    # domain.add_pieces(  randi() % 20 )
    domain.add_pieces(  1 )

    var total_events = domain.game_event_queue.size()
    print("!!!!!!!!!!!!!!!!!!!!!! ---------> Total domain events in queue: ", total_events, " total time: ", total_time)
    
    ##while not domain.game_event_queue.is_empty():
    ##    print("!!!!!!!!!!!!!!!!!!!!!! ---------> Processing domain event...")
    ##    consume_domain_event()
    ##    print("!!!!!!!!!!!!!!!!!!!!!! ---------> Domain event processed.")

    # consume one vent per frame
    ## if not domain.game_event_queue.is_empty():
    ##     consume_domain_event()

    # consume up to 5 events per frame
    var events_to_process = min(batch_size, total_events)
    for i in range(events_to_process):
        consume_domain_event()

    total_time += delta
    # var _total_time = int(total_time)
    # if ( _total_time % 5 == 0 ):

    # map domain game state to app game state
    var game_state = domain.game_state
    var app_state = GameControllerState.new()
    app_state.num_pieces = game_state.num_pieces
    app_state.previous_queue_size = current_queue_size
    app_state.current_turn = game_state.current_turn
    app_state.score = game_state.score.duplicate()
    app_state.is_game_over = game_state.is_game_over
    app_state.is_paused = game_state.is_paused
    app_state.version = game_state.version

    game_state_changed.emit(app_state)

func consume_domain_event() -> void:
    var event = domain.game_event_queue.dequeue()
    if event.type in handlers:
        handlers[event.type].call(event)
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
    if event.is_action_pressed("add_piece"):
        domain.add_pieces(100)
    pass


