extends Node
## This is a simple event bus using Godot signals.
## It allows different parts of the application to communicate
## without direct references to each other.

signal cmd_start_game()
signal cmd_end_game()
signal cmd_reset_game()
signal cmd_undo_move()
signal cmd_redo_move()
signal cmd_quit_game()
signal cmd_load_scene(scene_name: String)
signal cmd_toggle_pause(is_paused: bool)
signal cmd_game_over(winner: String)



##
signal evt_game_started()
signal evt_game_ended()
signal evt_game_reset()
signal evt_move_undone()
signal evt_move_redone()
signal evt_scene_loaded(scene_name: String)
signal evt_piece_added(id: int, position: int)