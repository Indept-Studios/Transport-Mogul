extends Control

signal contract_selected(vehicle: Vehicle, contract: Contract)

@onready var overlay: ColorRect = $Overlay
@onready var popup_panel: PanelContainer = $PopupPanel
@onready var contract_buttons := [
	$PopupPanel/MarginContainer/VBoxContainer/ContractButton0,
	$PopupPanel/MarginContainer/VBoxContainer/ContractButton1,
	$PopupPanel/MarginContainer/VBoxContainer/ContractButton2
]

var current_vehicle: Vehicle = null

func _ready() -> void:
	visible = false

	overlay.gui_input.connect(_on_overlay_gui_input)

	contract_buttons[0].pressed.connect(func(): _on_contract_button_pressed(0))
	contract_buttons[1].pressed.connect(func(): _on_contract_button_pressed(1))
	contract_buttons[2].pressed.connect(func(): _on_contract_button_pressed(2))

func show_for_vehicle(vehicle: Vehicle) -> void:
	if vehicle == null:
		return

	if not vehicle.is_available:
		return

	if vehicle.available_contracts.size() < 3:
		return

	current_vehicle = vehicle

	for i in range(3):
		var c: Contract = vehicle.available_contracts[i]

		var type_part := ""
		if Gamestate.get_reputation_tier() >= 2:
			if Gamestate.reputation >= 50:
				var tag := "STD"
				if c.type == "express":
					tag = "EXP"
				type_part = tag + " | "
			else:
				type_part = c.type + " | "

		contract_buttons[i].text = "%s | %s$%d | +%d Rep" % [
			Constants.format_duration(c.duration),
			type_part,
			c.reward,
			c.reputation_gain
		]
		contract_buttons[i].disabled = false

	visible = true

func close_popup() -> void:
	visible = false
	current_vehicle = null

func _on_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_popup()

func _on_contract_button_pressed(index: int) -> void:
	if current_vehicle == null:
		return

	if current_vehicle.available_contracts.size() <= index:
		return

	var contract: Contract = current_vehicle.available_contracts[index]
	emit_signal("contract_selected", current_vehicle, contract)
	close_popup()
