extends Node

@onready var main_menu = $MainMenu
@onready var game = $Game
@onready var game_manager = $Game/GameManager
@onready var game_ui = $Game/UI

func _ready() -> void:
	main_menu.game = game
	main_menu.game_ui = game_ui
	main_menu.game_manager = game_manager

	game.visible = false
	game_ui.visible = false
	main_menu.visible = true
