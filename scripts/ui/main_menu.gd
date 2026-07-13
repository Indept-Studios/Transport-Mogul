extends Control

func _on_new_game_btn_pressed():
	Transition.play_transistion()
	await Transition.on_transition_finished
	GameManager.start_new_game()
	get_tree().change_scene_to_file("uid://cvoy6tb7y2olh")

func _on_options_btn_pressed():
	Transition.play_transistion()
	await Transition.on_transition_finished
	get_tree().change_scene_to_packed(null)

func _on_exit_btn_pressed():
	get_tree().quit()
