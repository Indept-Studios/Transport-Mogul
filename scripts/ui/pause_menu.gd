extends CanvasLayer

@export var unsaved_seconds_threshold: int = 120

@onready var popup_layer: Control = $PopupLayer
@onready var overlay: ColorRect = $PopupLayer/Overlay
@onready var resume_button: Button = $PopupLayer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var save_button: Button = $PopupLayer/PanelContainer/MarginContainer/VBoxContainer/SaveButton
@onready var load_button: Button = $PopupLayer/PanelContainer/MarginContainer/VBoxContainer/LoadButton
@onready var quit_to_menu_button: Button = $PopupLayer/PanelContainer/MarginContainer/VBoxContainer/QuitToMenuButton
@onready var quit_game_button: Button = $PopupLayer/PanelContainer/MarginContainer/VBoxContainer/QuitGameButton
@onready var quit_confirm: ConfirmationDialog = $QuitConfirm
@onready var main_menu: CanvasLayer = $"../../MainMenu"
@onready var save_flash: ColorRect = $SaveFlash

var _pending_quit_mode: String = ""
var game_manager: Node
var game_ui: CanvasLayer

func _ready():
	popup_layer.visible = false
	overlay.gui_input.connect(_on_overlay_gui_input)
	resume_button.pressed.connect(_on_resume_pressed)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	quit_to_menu_button.pressed.connect(_on_quit_to_menu_pressed)
	quit_game_button.pressed.connect(_on_quit_game_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()
		get_viewport().set_input_as_handled()

func toggle_pause_menu() -> void:
	if popup_layer.visible:
		close()
	else:
		open()

func open() -> void:
	save_button.disabled = not Gamestate.is_dirty
	popup_layer.visible = true
	get_tree().paused = true

func close() -> void:
	popup_layer.visible = false
	get_tree().paused = false

func _on_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close()

func _on_resume_pressed() -> void:
	close()

func _on_save_pressed() -> void:
	if Gamestate.save_game():
		await _play_save_flash()
	close()

func _play_save_flash() -> void:
	save_flash.visible = true
	save_flash.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	save_flash.color = Color(0.0, 1.0, 0.25, 1.0)
	save_flash.self_modulate = Color(1, 1, 1, 0)

	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(save_flash, "self_modulate:a", 0.8, 0.12)
	tween.tween_property(save_flash, "self_modulate:a", 0.0, 0.25)

	await tween.finished

func _on_load_pressed() -> void:
	if Gamestate.load_game():
		game_manager.start_from_loaded_game()
	close()

func _needs_quit_warning() -> bool:
	if not Gamestate.is_dirty:
		return false
	var now := int(Time.get_unix_time_from_system())
	if Gamestate.last_save_unix <= 0:
		return true
	return (now - Gamestate.last_save_unix) >= unsaved_seconds_threshold

func _prompt_quit(mode: String) -> void:
	_pending_quit_mode = mode
	quit_confirm.dialog_text = "Unsaved progress detected. Save before exiting?"
	quit_confirm.ok_button_text = "save and exit"
	quit_confirm.cancel_button_text = "cancle"
	quit_confirm.popup_centered()

func _on_quit_to_menu_pressed() -> void:
	if _needs_quit_warning():
		_prompt_quit("menu")
		return
	_quit_to_menu()

func _on_quit_game_pressed() -> void:
	if _needs_quit_warning():
		_prompt_quit("game")
		return
	_quit_game()

func _on_quit_confirmed() -> void:
	Gamestate.save_game()
	if _pending_quit_mode == "menu":
		_quit_to_menu()
	elif _pending_quit_mode == "game":
		_quit_game()

func _quit_to_menu() -> void:
	close()
	game_ui.visible = false
	main_menu.visible = true
	main_menu.show_menu()

func _quit_game() -> void:
	get_tree().quit()
