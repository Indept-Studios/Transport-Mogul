extends Control

@onready var resolution_btn = $CenterContainer/MarginContainer/VBoxContainer/ResolutionBtn

func _ready():
	var current := DisplayServer.window_get_size()
	print(resolution_btn.item_count)
	for i in resolution_btn.item_count:
		if resolution_btn.get_item_text(i) == "%dx%d" % [current.x, current.y]:
			resolution_btn.select(i)
			print(i)
			break

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, value) 

func _on_mute_btn_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)

func _on_resolution_btn_item_selected(index):
	match index:
		0:
			resolution_btn.select(0)
			DisplayServer.window_set_size(Vector2i(1280,720))
		1:
			resolution_btn.select(1)
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			resolution_btn.select(2)
			DisplayServer.window_set_size(Vector2i(1920,1080))
		3:
			resolution_btn.select(3)
			DisplayServer.window_set_size(Vector2i(2560,1440))


func _on_back_btn_pressed():
	Transition.play_transistion()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("uid://dgtixi54nyyd6")
