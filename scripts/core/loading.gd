extends Control

const SAVE_SLOT = preload("uid://bx8rfbb1nkc6f")

@onready var holder = %Holder

func _ready():
	load_save_slots()

func load_save_slots():
	for save in SavegameManager.get_save_list():
		var slot = SAVE_SLOT.instantiate()
		holder.add_child(slot)
		slot.setup(save)
		slot.load_pressed.connect(_on_load_pressed)

func _on_load_pressed(save_path: String) -> void:
	SavegameManager.load_game(save_path)
	GameManager.start_from_loaded_game()
	await _transition()
	get_tree().change_scene_to_file(Constants.GAME_SCENE)

	
func _transition():
	Transition.play_transistion()
	await Transition.on_transition_finished

func _on_back_btn_pressed():
	await _transition()
	get_tree().change_scene_to_file("uid://dgtixi54nyyd6")
