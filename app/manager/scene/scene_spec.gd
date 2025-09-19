extends Resource
class_name SceneSpec
# This is a placeholder for scene specifications.
# You can expand it with properties and methods as needed.
# For example, you might want to define scene types, configurations, etc.
enum SceneType {
    MAIN_MENU,
    GAME_BOARD,
    SETTINGS,
    PAUSE_MENU,
    GAME_OVER
}
@export var name: String
@export var packed: PackedScene
@export var is_singleton: bool = true
@export var close_others: bool = true
@export var is_modal: bool = false
@export var is_pausable: bool = true
@export var type_scene: SceneType = SceneType.MAIN_MENU 