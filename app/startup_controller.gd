extends Node
class_name StartupController

@export var scene_host_path: NodePath
@onready var host: Node = get_node(scene_host_path)

var game_controller: GameController = null
var scenes_controller: ScenesController = null


func _ready() -> void:
    print("StartupController is ready")

    # Instantiate ScenesController and add it as a child
    # UI host for menus, dialogs, overlays, etc. 2D host for game scenes
    var ui_host = Node.new()
    ui_host.name = "UiHost"
    add_child(ui_host)
    var scene_host_2d := Node2D.new()
    scene_host_2d.name = "SceneHost2D"
    add_child(scene_host_2d)

    scenes_controller = ScenesController.new(scene_host_2d, ui_host)
    add_child(scenes_controller)
    scenes_controller.name = "ScenesController"
    scenes_controller.add_to_group("scenes_controller")
    DependencyHelper.set_instance("scenes_controller", scenes_controller)


    # Instantiate GameController and add it as a child
    var game_host = Node.new()
    game_host.name = "GameHost"
    add_sibling.call_deferred(game_host)

    game_controller = GameController.new()
    game_host.add_child(game_controller)
    game_controller.name = "GameController"
    game_controller.add_to_group("game_controller")
    DependencyHelper.set_instance("game_controller", game_controller)


    


    scenes_controller.open_main_menu()
    pass # Replace with function body.
