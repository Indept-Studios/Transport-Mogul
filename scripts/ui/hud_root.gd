extends Control

const VEHICLE_CARD = preload("uid://c2rgh1g0l64ud")

@onready var time_label: Label = %TimeLabel
@onready var money_label = %MoneyLabel
@onready var reputation_label = %ReputationLabel
@onready var progress_bar = %ProgressBar
@onready var company_level_panel = %CompanyLevelPanel
@onready var vehicle_holder = %VehicleHolder
@onready var status_label = %StatusLabel
@onready var popup_layer = $PopupLayer
@onready var bottom_container = $BottomContainer
@onready var active_vehicles_label = %ActiveVehiclesLabel
@onready var idle_vehicles_label = %IdleVehiclesLabel

func _ready():
	TimeSystem.updated.connect(update_clock)
	update_clock(TimeSystem.date_time)
	Gamestate.resources_changed.connect(update_resources)
	Gamestate.vehicles_changed.connect(rebuild_vehicle_cards)
	StatusLog.changed.connect(_on_status_changed)
	popup_layer.contract_selected.connect(_on_contract_selected)
	
	update_resources()
	rebuild_vehicle_cards()
	_on_status_changed()
	
	get_viewport().size_changed.connect(_apply_bottom_height)

func _process(_delta: float) -> void:
	update_vehicle_status()
	for child in vehicle_holder.get_children():
		if child is VehicleCard:
			child.update_view()

func update_vehicle_status() -> void:
	var active := 0
	var idle := 0

	for v in Gamestate.vehicles:
		if v.is_available:
			idle += 1
		else:
			active += 1
	active_vehicles_label.text = "Active vehicles: %d" % active
	idle_vehicles_label.text = "Idle vehicles: %d" % idle

func update_clock(date_time: DateTime) -> void:
	time_label.text = "%02d:%02d:%02d" % [
		date_time.hours,
		date_time.minutes,
		date_time.seconds
	]

func update_resources() -> void:
	money_label.text = "$%d" % Gamestate.money
	reputation_label.text = "Rep.: %d" % Gamestate.reputation
	progress_bar.value = Gamestate.reputation
	company_level_panel.text = str("lvl.: %d" % Gamestate.tier)

func rebuild_vehicle_cards() -> void:
	for child in vehicle_holder.get_children():
		vehicle_holder.remove_child(child)
		child.queue_free()

	for vehicle in Gamestate.vehicles:
		var card: VehicleCard = VEHICLE_CARD.instantiate()
		vehicle_holder.add_child(card)
		card.setup(vehicle)
		card.clicked.connect(_on_vehicle_card_clicked)

func _on_vehicle_card_clicked(vehicle: Vehicle) -> void:
	popup_layer.show_for_vehicle(vehicle)

func _on_contract_selected(vehicle: Vehicle, contract: Contract) -> void:
	GameManager.assign_contract(vehicle, contract)

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
