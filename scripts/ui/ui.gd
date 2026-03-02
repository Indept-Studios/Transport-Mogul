extends CanvasLayer

@onready var popup_layer: Control = $PopupLayer
@onready var overlay: ColorRect = $PopupLayer/Overlay
@onready var money_label = $TopBar/MoneyLabel
@onready var reputation_label = $TopBar/ReputationLabel
@onready var holder = $BottomContainer/VehicleArea/VehicleHolder
@onready var contract_popup: PanelContainer = $PopupLayer/ContractPopup
@onready var contract_buttons := [
	$PopupLayer/ContractPopup/MarginContainer/VBoxContainer/ContractButton0,
	$PopupLayer/ContractPopup/MarginContainer/VBoxContainer/ContractButton1,
	$PopupLayer/ContractPopup/MarginContainer/VBoxContainer/ContractButton2
	]
@onready var game_manager: Node = $"../GameManager"
@onready var bottom_container: Control = $BottomContainer

@export var vehicle_card_scene: PackedScene
var current_vehicle: Vehicle = null

func _ready():
	var card = vehicle_card_scene.instantiate()
	if vehicle_card_scene == null:
		return
	Gamestate.resources_changed.connect(update_resources)
	Gamestate.vehicles_changed.connect(rebuild_vehicle_cards)

	contract_buttons[0].pressed.connect(func(): _on_contract_button_pressed(0))
	contract_buttons[1].pressed.connect(func(): _on_contract_button_pressed(1))
	contract_buttons[2].pressed.connect(func(): _on_contract_button_pressed(2))

	_apply_bottom_height()
	get_viewport().size_changed.connect(_apply_bottom_height)
	contract_popup.visible = false
	update_resources()
	rebuild_vehicle_cards()
	overlay.gui_input.connect(_on_overlay_gui_input)
	popup_layer.visible = false
	
func _process(delta):
	for child in holder.get_children():
		if child is VehicleCard:
			child.update_view()

func _on_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_contract_popup()

func _apply_bottom_height() -> void:
	var h := get_viewport().get_visible_rect().size.y
	var target := int(h * 0.2) # 1/5

	target = clamp(target, 140, 260)

	bottom_container.custom_minimum_size.y = target

func update_resources():
	money_label.text = "Geld: %d" % Gamestate.money
	reputation_label.text = "Ruf: %d" % Gamestate.reputation

func rebuild_vehicle_cards():
	for child in holder.get_children():
		holder.remove_child(child)
		child.queue_free()

	for vehicle in Gamestate.vehicles:
		var card = vehicle_card_scene.instantiate()
		holder.add_child(card)
		card.setup(vehicle)
		card.clicked.connect(_on_vehicle_card_clicked)
		
func _on_vehicle_card_clicked(vehicle: Vehicle) -> void:
	current_vehicle = vehicle
	_show_contract_popup(vehicle)
	
func _show_contract_popup(vehicle: Vehicle) -> void:
	current_vehicle = vehicle
	popup_layer.visible = true
	contract_popup.visible = true
	if vehicle.available_contracts.size() < 3:
		pass
	for i in range(3):
		var c: Contract = vehicle.available_contracts[i]
		contract_buttons[i].text = "%ds | $%d | +%d Ruf" % [int(c.duration), c.reward, c.reputation_gain]
		contract_buttons[i].disabled = false

func _on_contract_button_pressed(index: int) -> void:
	if current_vehicle == null:
		return
	if current_vehicle.available_contracts.size() <= index:
		return
	var c: Contract = current_vehicle.available_contracts[index]
	game_manager.assign_contract(current_vehicle, c)
	close_contract_popup()

func close_contract_popup() -> void:
	$PopupLayer.visible = false
	current_vehicle = null
