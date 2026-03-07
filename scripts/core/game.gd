extends Node2D

@onready var game_manager = $GameManager
@onready var ui = $UI
@onready var pause_menu = $PauseMenu

func _ready() -> void:
	ui.game_manager = game_manager
	pause_menu.game_manager = game_manager
	pause_menu.game_ui = ui
