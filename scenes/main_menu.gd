extends Node2D

# Ensure the ScenesController class is either defined or imported
@onready var scenes_controller = DependencyHelper.get_instance("scenes_controller") as ScenesController
@onready var start_button = $Button
@onready var game_controller: GameController = DependencyHelper.get_instance("game_controller") as GameController

func _ready() -> void:
	print("MainMenu is ready")

	start_button.pressed.connect(func() -> void:
		print("Start button pressed")
		scenes_controller.open_board_scene()
		# Here you can add logic to start the game, e.g., switch to the game scene
	)
