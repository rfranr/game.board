extends Node
## This is a simple event bus using Godot signals.
## It allows different parts of the application to communicate
## without direct references to each other.

signal cmd_open_config()
signal cmd_open_main_menu()
signal cmd_show_message(message: String)
signal cmd_hide_message()