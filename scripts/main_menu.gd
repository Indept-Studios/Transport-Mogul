extends CanvasLayer

@onready var continue_button: Button = $PanelContainer/VBoxContainer/ContinueButton
@onready var new_game_button: Button = $PanelContainer/VBoxContainer/NewGameButton
@onready var quit_button: Button = $PanelContainer/VBoxContainer/QuitButton
@onready var game_ui: CanvasLayer = $"../UI"
@onready var game_manager: Node = $"../GameManager"

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	_refresh()

func _refresh():
	continue_button.disabled = not Gamestate.has_save()
	game_ui.visible = false
	visible = true

func _start_game():
	game_ui.visible = true
	visible = false

func _on_continue_pressed():
	if Gamestate.load_game():
		game_manager.start_from_loaded_game()
		_start_game()

func _on_new_game_pressed():
	game_manager.start_new_game()
	_start_game()

func _on_quit_pressed():
	get_tree().quit()
