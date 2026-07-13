class_name SaveSlot extends PanelContainer

signal load_pressed(data: Dictionary)

@onready var name_label = %NameLabel
@onready var info_label = %InfoLabel
@onready var load_button = %LoadButton

var save_data: Dictionary

func setup(data: Dictionary):
	save_data = data
	name_label.text = data.get("save_name", "Unknown")
	info_label.text = "Day %d | %02d:%02d:%02d | $%d | Rep. %d | %d Vehicles" % [
		data.get("days", 0),
		data.get("hours", 0),
		data.get("minutes", 0),
		data.get("seconds", 0),
		data.get("money", 0),
		data.get("reputation", 0),
		data.get("vehicles", 0)
	]

func _on_load_button_pressed():
	load_pressed.emit(save_data["save_name"])
