extends Node
class_name ScenesController

const MAIN_MENU_SCN: PackedScene = preload("res://scenes/MainMenu.tscn")
const BOARD_SCN: PackedScene     = preload("res://scenes/BoardView.tscn")


var scenes: Array = []
var root_node: Node = null
var host: Node = null

func _init(_host: Node) -> void:
	self.host = _host

func _ready() -> void:
	print("ScenesController is ready")
	root_node = get_tree().get_root().get_node("Main").get_child(0) as Node


func _close_all_scenes() -> void:
	for scene in scenes:
		scene.queue_free()
	scenes.clear()
	print("All scenes closed.")


func _set_scene(scene: Node) -> void:
	_close_all_scenes()
	host.add_child(scene)
	scenes.append(scene)
	print("Scene set and connected.")

func open_main_menu() -> void:
	_set_scene(MAIN_MENU_SCN.instantiate())

func open_board_scene() -> void:
	_set_scene(BOARD_SCN.instantiate())
