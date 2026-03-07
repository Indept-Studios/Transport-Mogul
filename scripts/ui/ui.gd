extends CanvasLayer

@export var vehicle_card_scene: PackedScene

@onready var money_label: Label = $TopBar/CompanyInfoBox/MoneyLabel
@onready var reputation_label: Label = $TopBar/CompanyInfoBox/ProgressBar/Reputation
@onready var reputation_bar: = $TopBar/CompanyInfoBox/ProgressBar
@onready var holder: HBoxContainer = $BottomContainer/VehicleArea/VehicleHolder
@onready var bottom_container: Control = $BottomContainer
@onready var status_label: Label = $BottomContainer/StatusArea/StatusBar/StatusLabel
@onready var contract_popup: Control = $PopupLayer
@onready var buy_button: Button = $"BuyButton(DEBUG)"
@onready var time_label: Label = $TopBar/GameInfoBox/TimeLabel
@onready var active_label: Label = $TopBar/GameInfoBox/ActiveVehiclesLabel
@onready var idle_label: Label = $TopBar/GameInfoBox/IdleVehiclesLabel

var game_manager: Node

func _ready() -> void:
	Gamestate.resources_changed.connect(update_resources)
	Gamestate.vehicles_changed.connect(rebuild_vehicle_cards)
	StatusLog.changed.connect(_on_status_changed)
	buy_button.pressed.connect(_on_buy_pressed)
	contract_popup.contract_selected.connect(_on_contract_selected)

	update_resources()
	rebuild_vehicle_cards()
	_on_status_changed()

	_apply_bottom_height()
	get_viewport().size_changed.connect(_apply_bottom_height)
	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(update_clock)
	timer.autostart = true
	add_child(timer)

func _process(_delta: float) -> void:
	update_vehicle_status()
	for child in holder.get_children():
		if child is VehicleCard:
			child.update_view()

func update_resources() -> void:
	money_label.text = "Money: %d" % Gamestate.money
	reputation_label.text = "Reputation: %d" % Gamestate.reputation
	reputation_bar.value = Gamestate.reputation

func _on_buy_pressed() -> void:
	if Constants.DEBUGFLAG:
		game_manager.add_vehicle(game_manager.create_vehicle())
	else:
		game_manager.buy_vehicle()

func update_clock() -> void:
	var t := Time.get_datetime_dict_from_system()
	time_label.text = "%02d:%02d:%02d" % [t.hour, t.minute, t.second]

func update_vehicle_status() -> void:
	var active := 0
	var idle := 0

	for v in Gamestate.vehicles:
		if v.is_available:
			idle += 1
		else:
			active += 1
	active_label.text = "Active vehicles: %d" % active
	idle_label.text = "Idle vehicles: %d" % idle

func rebuild_vehicle_cards() -> void:
	for child in holder.get_children():
		holder.remove_child(child)
		child.queue_free()

	for vehicle in Gamestate.vehicles:
		var card: VehicleCard = vehicle_card_scene.instantiate()
		holder.add_child(card)
		card.setup(vehicle)
		card.clicked.connect(_on_vehicle_card_clicked)

func _on_vehicle_card_clicked(vehicle: Vehicle) -> void:
	contract_popup.show_for_vehicle(vehicle)

func _on_contract_selected(vehicle: Vehicle, contract: Contract) -> void:
	game_manager.assign_contract(vehicle, contract)

func _on_status_changed() -> void:
	var latest: Array = StatusLog.get_latest(1)
	if latest.size() == 0:
		status_label.text = ""
	else:
		status_label.text = str(latest[0].get("msg", ""))

func _apply_bottom_height() -> void:
	var height: int = int(get_viewport().get_visible_rect().size.y * 0.2)
	height = clamp(height, 140, 260)
	bottom_container.custom_minimum_size.y = height
