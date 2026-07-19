extends Control

var is_paused := false

@onready var resume_button = %ResumeButton
@onready var save_button = %SaveButton
@onready var load_button = %LoadButton
@onready var quit_to_menu_button = %QuitToMenuButton
@onready var quit_game_button = %QuitGameButton

func _ready():
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if is_paused:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()

func resume():
	is_paused = false
	hide()
	get_tree().paused = false
	
func pause():
	is_paused = true
	show()
	get_tree().paused = true
	resume_button.grab_focus()
	
func _on_resume_button_pressed():
	resume()


func _on_save_button_pressed():
	SavegameManager.save_game()


func _on_load_button_pressed():
	resume()
	await _transition()
	get_tree().change_scene_to_file("uid://cnrfudn8evfj7")


func _on_quit_to_menu_button_pressed():
	resume()
	await _transition()
	get_tree().change_scene_to_file(Constants.MAIN_SCENE)

func _on_quit_game_button_pressed():
	get_tree().quit()

func _transition():
	Transition.play_transistion()
	await Transition.on_transition_finished
	
