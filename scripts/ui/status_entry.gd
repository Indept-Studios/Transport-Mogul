extends PanelContainer

signal delete_requested(id: int)

@onready var entry_label: Label = $HBoxContainer/EntryLabel
@onready var delete_button: Button = $HBoxContainer/DeleteButton

var entry_id: int = -1

func setup(entry: Dictionary) -> void:
	entry_id = int(entry.get("id", -1))
	entry_label.text = str(entry.get("msg", ""))
	delete_button.pressed.connect(func(): emit_signal("delete_requested", entry_id))
