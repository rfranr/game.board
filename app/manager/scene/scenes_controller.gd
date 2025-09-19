extends Node
class_name ScenesController

#@onready var game_controller: GameController = DependencyHelper.get_instance("game_controller") as GameController


var MAIN_MENU: SceneSpec = preload("res://app/manager/scene/trees/main_menu.tres")
var BOARD: SceneSpec     = preload("res://app/manager/scene/trees/board_view.tres")
var CONFIG: SceneSpec    = preload("res://app/manager/scene/trees/config_view.tres")


var ui_host: Node
var scenes_host: Node2D = null
var game_state: GameState = null

signal scene_changed(prev: Node, next: Node)

# Keeps at most one live instance per scene resource
var _singletons: Dictionary = {}   # key: String (resource_path) -> Node

var _scenes : Array[Dictionary] = []

func _init(_scenes_host: Node2D, _ui_host: Node) -> void:
    scenes_host = Node2D.new()
    scenes_host.name = "SceneHost2D"
    _scenes_host.add_child(scenes_host)

    ui_host = Node.new()
    ui_host.name = "SceneHost"
    _ui_host.add_child(ui_host)
pass

func _ready() -> void:
    assert(ui_host != null, "ScenesController: ui_host is null. Pass a valid ui_host to _init().")
    #game_state = game_controller.domain.game_state
    #game_state.connect("is_paused_changed", Callable(self, "_on_game_paused_changed"))


func _clear_host() -> void:
    for c in ui_host.get_children():
        c.queue_free()
    _singletons.clear()

func _clear_scene(packed: PackedScene) -> void:
    var key := packed.resource_path
    var existing: Node = _singletons.get(key)
    if existing and is_instance_valid(existing) and existing.get_parent():
        existing.queue_free()
        _singletons.erase(key)

func _clear_previous_scene() -> void:
    if ui_host.get_child_count() > 0:
        var prev: Node = ui_host.get_child(ui_host.get_child_count() - 1)
        if prev:
            ##var key: String = str(prev.filename)
            ##if key in _singletons:
            ##    _singletons.erase(key)
            prev.queue_free()

func _set_scene(packed: PackedScene, sceneSpec: SceneSpec) -> Node:
    var prev: Node = ui_host.get_child(ui_host.get_child_count() - 1) if ui_host.get_child_count() > 0 else null
    var inst := packed.instantiate()
    inst.set_meta("scene_spec", sceneSpec)
    ui_host.add_child(inst)
    _singletons[packed.resource_path] = inst
    emit_signal("scene_changed", prev, inst)
    return inst

func _set_scene_2d(packed: PackedScene, sceneSpec: SceneSpec) -> Node:
    var prev: Node = scenes_host.get_child(scenes_host.get_child_count() - 1) if scenes_host.get_child_count() > 0 else null
    var inst := packed.instantiate()
    inst.set_meta("scene_spec", sceneSpec)
    scenes_host.add_child(inst)
    _singletons[packed.resource_path] = inst
    emit_signal("scene_changed", prev, inst)
    return inst    

func _set_scene_from_spec(spec: SceneSpec) -> Node:
    if spec.is_modal:
        _toggle_scene(spec.packed)
        return null
    
    if spec.close_others:
        _clear_host()

    if spec.type_scene == SceneSpec.SceneType.GAME_BOARD:
        var inst := _set_scene_2d(spec.packed, spec)
        _scenes.append({"spec": spec, "instance": inst})    
        return inst
    else:
        var inst := _set_scene(spec.packed, spec)
        _scenes.append({"spec": spec, "instance": inst})
        return inst
pass

func _toggle_scene(packed: PackedScene) -> Node:
    var key := packed.resource_path
    var existing: Node = _singletons.get(key)
    if existing and is_instance_valid(existing) and existing.get_parent():
        existing.queue_free()
        _singletons.erase(key)
        return null
    var inst := packed.instantiate()
    ui_host.add_child(inst)
    _singletons[key] = inst
    emit_signal("scene_changed", null, inst)
    return inst

# --- Commands ---
func open_main_menu() -> Node:
    return _set_scene_from_spec(MAIN_MENU)

func open_board_scene() -> Node:
    return _set_scene_from_spec(BOARD)

func open_config_scene() -> Node:
    return _set_scene_from_spec(CONFIG)

func close_current_scene() -> void:
    _clear_previous_scene()

func pause_scene() -> void:
    for c: Node in ui_host.get_children():
        var specs = c.get_meta("scene_spec")
        if specs and specs.is_pausable:
            c.process_mode = Node.PROCESS_MODE_DISABLED

func resume_scene() -> void:
    get_tree().paused = false
    for c: Node in ui_host.get_children():
        var specs = c.get_meta("scene_spec")
        if specs and specs.is_pausable:
            c.process_mode = Node.PROCESS_MODE_INHERIT

func _on_game_paused_changed(is_paused: bool) -> void:
    if is_paused:
        pause_scene()
    else:
        resume_scene()
