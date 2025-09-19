extends Node
@onready var option_button: OptionButton = $OptionButton
@onready var text_edit: TextEdit = $TextEdit
@onready var text_edit2: TextEdit = $TextEdit2
@onready var label: Label = $Label

@onready var game_controller: GameController = DependencyHelper.get_instance("game_controller") as GameController

var num_pieces : int = 0

func _ready() -> void:
    var game_state = game_controller.domain.game_state
    game_controller.game_state_changed.connect(_on_game_state_changed)

    DomainBus.evt_piece_added.connect(func(_id: int, _x:int, _y:int) -> void: 
        num_pieces += 1
        var size_queue = game_controller.domain.game_event_queue.size()
        label.text = "Number of pieces: " + str(num_pieces) + " Event queue size: " + str(size_queue)
    )

    DomainBus.evt_pieces_added.connect(func(positions: Array[Dictionary]) -> void:
        num_pieces += positions.size()
        var size_queue = game_controller.domain.game_event_queue.size()
        label.text = "Number of pieces: " + str(num_pieces) + " Event queue size: " + str(size_queue)
    )


    game_state.connect("is_paused_changed", Callable(self, "_on_game_paused_changed"))
    _update_ui(game_state.is_paused)

func _on_game_paused_changed(is_paused: bool) -> void:
    _update_ui(is_paused)

func _on_game_state_changed(new_state: GameControllerState) -> void:
    print("ConfigView: Game state changed to ", new_state.num_pieces)
    ## var current_turn: int = 0
    ## var score: Dictionary = {"player1": 0, "player2": 0}
    ## var is_game_over: bool = false
    ## var is_paused: bool = false
    ## var version: int = 0
    ## var num_pieces: int = 0
    var lines = [
        "Version: " + str(new_state.version),
        "Current Turn: " + str(new_state.current_turn),
        "Score: " + str(new_state.score),
        "Is Game Over: " + str(new_state.is_game_over),
        "Is Paused: " + str(new_state.is_paused),
        "Num Pieces: " + str(new_state.num_pieces)
    ]
    text_edit2.text = "\n" + "\n".join(lines)



func _update_ui(is_paused: bool) -> void:
    if is_paused:
        print("Game is paused, hiding option button")
        option_button.set_item_disabled(0, true)
        text_edit.text = "Game is paused."
    else:
        print("Game is running, showing option button")
        option_button.set_item_disabled(0, false)
        text_edit.text = "Game is running."