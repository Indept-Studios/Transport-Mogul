extends Control

func _ready():
	%NewGameBtn.grab_focus()

func _on_new_game_btn_pressed():
	await _transition()
	GameManager.start_new_game()
	get_tree().change_scene_to_file("uid://cvoy6tb7y2olh")

func _on_load_btn_pressed():
	await _transition()
	get_tree().change_scene_to_file("uid://cnrfudn8evfj7")

func _on_options_btn_pressed():
	await _transition()
	get_tree().change_scene_to_packed(null)

func _on_exit_btn_pressed():
	get_tree().quit()

func _transition():
	Transition.play_transistion()
	await Transition.on_transition_finished
