extends Node2D

@onready var ui = $UI
@onready var pause_menu = $PauseMenu

func _ready() -> void:
	pause_menu.game_ui = ui
