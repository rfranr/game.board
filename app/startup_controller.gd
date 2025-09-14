extends Node
class_name StartupController

@export var scene_host_path: NodePath
@onready var host: Node = get_node(scene_host_path)

var game_controller: GameController = null
var scenes_controller: ScenesController = null


func _ready() -> void:
	print("StartupController is ready")

	# Instantiate ScenesController and add it as a child
	scenes_controller = ScenesController.new(host)
	add_child(scenes_controller)
	scenes_controller.name = "ScenesController"
	scenes_controller.add_to_group("scenes_controller")
	DependencyHelper.set_instance("scenes_controller", scenes_controller)


	# Instantiate GameController and add it as a child
	game_controller = GameController.new()
	add_child(game_controller)
	game_controller.name = "GameController"
	game_controller.add_to_group("game_controller")
	DependencyHelper.set_instance("game_controller", game_controller)


    


	scenes_controller.open_main_menu()
	pass # Replace with function body.
