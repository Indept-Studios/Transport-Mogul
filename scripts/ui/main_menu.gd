extends CanvasLayer

@onready var continue_button: Button = $PanelContainer/VBoxContainer/ContinueButton
@onready var new_game_button: Button = $PanelContainer/VBoxContainer/NewGameButton
@onready var quit_button: Button = $PanelContainer/VBoxContainer/QuitButton

var game: Node = null
var game_ui: CanvasLayer = null
var game_manager: Node = null

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	_refresh()

func _refresh() -> void:
	continue_button.disabled = not Gamestate.has_save()
	visible = true

func show_menu() -> void:
	_refresh()

func _start_game() -> void:
	if game != null:
		game.visible = true
	if game_ui != null:
		game_ui.visible = true
	visible = false

func _on_continue_pressed() -> void:
	if game_manager == null:
		return
	if Gamestate.load_game():
		game_manager.start_from_loaded_game()
		_start_game()

func _on_new_game_pressed() -> void:
	if game_manager == null:
		return
	game_manager.start_new_game()
	_start_game()

func _on_quit_pressed() -> void:
	get_tree().quit()
