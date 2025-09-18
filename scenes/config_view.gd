extends Node
@onready var option_button: OptionButton = $OptionButton
@onready var text_edit: TextEdit = $TextEdit

@onready var game_controller: GameController = DependencyHelper.get_instance("game_controller") as GameController


func _ready() -> void:
    print("ConfigView is ready")
    var game_state = game_controller.domain.game_state

    game_state.connect("is_paused_changed", Callable(self, "_on_game_paused_changed"))
    _update_ui(game_state.is_paused)

func _on_game_paused_changed(is_paused: bool) -> void:
    _update_ui(is_paused)

func _update_ui(is_paused: bool) -> void:
    if is_paused:
        print("Game is paused, hiding option button")
        option_button.set_item_disabled(0, true)
        text_edit.text = "Game is paused."
    else:
        print("Game is running, showing option button")
        option_button.set_item_disabled(0, false)
        text_edit.text = "Game is running."