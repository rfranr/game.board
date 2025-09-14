extends Node
class_name ScenesController

const MAIN_MENU_SCN: PackedScene = preload("res://scenes/MainMenu.tscn")
const BOARD_SCN: PackedScene     = preload("res://scenes/BoardView.tscn")
const CONFIG_SCN: PackedScene    = preload("res://scenes/ConfigView.tscn")

const MAIN_MENU: SceneSpec = preload("res://app/manager/scene/trees/main_menu.tres")


var host: Node
signal scene_changed(prev: Node, next: Node)

# Keeps at most one live instance per scene resource
var _singletons: Dictionary = {}   # key: String (resource_path) -> Node

var _scenes : Array[Dictionary] = []

func _init(_host: Node) -> void:
    host = _host

func _ready() -> void:
    assert(host != null, "ScenesController: host is null. Pass a valid host to _init().")

func _clear_host() -> void:
    for c in host.get_children():
        c.queue_free()
    _singletons.clear()
#    await get_tree().process_frame

func _clear_scene(packed: PackedScene) -> void:
    var key := packed.resource_path
    var existing: Node = _singletons.get(key)
    if existing and is_instance_valid(existing) and existing.get_parent():
        existing.queue_free()
        _singletons.erase(key)

func _clear_previous_scene() -> void:
    if host.get_child_count() > 0:
        var prev: Node = host.get_child(host.get_child_count() - 1)
        if prev:
            var key: String = str(prev.filename)
            if key in _singletons:
                _singletons.erase(key)
            prev.queue_free()

func _set_scene(packed: PackedScene, close_all := true) -> Node:
    var prev: Node = host.get_child(host.get_child_count() - 1) if host.get_child_count() > 0 else null
    if close_all:
        _clear_previous_scene()
    var inst := packed.instantiate()
    host.add_child(inst)
    _singletons[packed.resource_path] = inst
    emit_signal("scene_changed", prev, inst)
    return inst

func _set_scene_from_spec(spec: SceneSpec) -> Node:
    return _set_scene(spec.packed, spec.close_others)

func _toggle_scene(packed: PackedScene) -> Node:
    var key := packed.resource_path
    var existing: Node = _singletons.get(key)
    if existing and is_instance_valid(existing) and existing.get_parent():
        existing.queue_free()
        _singletons.erase(key)
        return null
    var inst := packed.instantiate()
    host.add_child(inst)
    _singletons[key] = inst
    emit_signal("scene_changed", null, inst)
    return inst

# --- Commands ---
func open_main_menu() -> Node:
    return _set_scene_from_spec(MAIN_MENU)

func open_board_scene() -> Node:
    return _set_scene(BOARD_SCN, true)

func toggle_config_scene() -> Node:
    return _toggle_scene(CONFIG_SCN)
