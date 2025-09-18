extends Node
class_name GameController

# Import the Piece class from domain/piece.gd
const Piece = preload("res://domain/piece.gd")
var domain: Domain = Domain.new()

# Array to hold the state of all pieces
var pieces: Array = []

# Array to hold the scenes loaded
var scenes: Array = []

# Controllers
var scenes_controller: ScenesController = null

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

    # Initialize the pieces array with some pieces
    pieces.append(Piece.new(1, Piece.eColor.WHITE, Vector2i(0, 0)))
    pieces.append(Piece.new(2, Piece.eColor.BLACK, Vector2i(1, 0)))
    # Print all pieces' details
    for piece in pieces:
        print("Piece ", piece.id, " color: ", piece.color, " position: ", piece.position)

func _process(delta: float) -> void:
    while not domain.game_event_queue.is_empty():
        consume_domain_event()

    total_time += delta
    # var _total_time = int(total_time)
    # if ( _total_time % 5 == 0 ):
    domain.add_pieces(1)
    pass # Replace with function body.


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
    pass


