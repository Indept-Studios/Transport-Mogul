extends Node

signal vehicles_changed
signal resources_changed
signal tier_changed

var money: int = Constants.START_MONEY
var reputation: int = Constants.START_REPUTATION
var tier: int = Constants.START_TIER
var vehicles: Array = []
var last_save_unix: int = 0
var is_dirty: bool = false

func add_vehicle(vehicle: Vehicle):
	vehicles.append(vehicle)
	is_dirty = true
	emit_signal("vehicles_changed")

func add_money(amount: int):
	money += amount
	is_dirty = true
	emit_signal("resources_changed")

func add_reputation(amount: int):
	reputation += amount
	is_dirty = true
	update_tier()
	emit_signal("resources_changed")

func update_tier() -> void:
	var new_tier := calculate_reputation_tier()

	if new_tier != tier:
		tier = new_tier
		emit_signal("tier_changed")

func calculate_reputation_tier() -> int:
	if reputation < 10:
		return 1
	elif reputation < 200:
		return 2
	elif reputation < 500:
		return 3
	elif reputation < 2000:
		return 4
	elif reputation < 5000:
		return 5
	else:
		return 6
	
func reset_game() -> void:
	money = Constants.START_MONEY
	reputation = Constants.START_REPUTATION
	vehicles.clear()
	Vehicle._next_id = 1
	emit_signal("resources_changed")
	emit_signal("vehicles_changed")

func apply_save_data(data: Dictionary) -> void:
	var dt = DateTime.new()
	var saved_time: Dictionary = data.get("date_time", {})

	dt.days = int(saved_time.get("days", 0))
	dt.hours = int(saved_time.get("hours", 8))
	dt.minutes = int(saved_time.get("minutes", 0))
	dt.seconds = int(saved_time.get("seconds", 0))
	TimeSystem.reset_time(dt.days, dt.hours, dt.minutes, dt.seconds)

	money = int(data.get("money", Constants.START_MONEY))
	reputation = int(data.get("reputation", Constants.START_REPUTATION))
	tier = int(data.get("tier_level", Constants.START_TIER))
	vehicles.clear()

	var vehicles_data : Dictionary = data.get("vehicles", {})
	for key in vehicles_data.keys():
		var vehicle_dict: Dictionary = vehicles_data[key]
		var vehicle := Vehicle.from_dict(vehicle_dict)
		vehicle.id = int(key)
		vehicles.append(vehicle)

	vehicles.sort_custom(func(a: Vehicle, b: Vehicle):
		return a.id < b.id
	)
	emit_signal("resources_changed")
	emit_signal("vehicles_changed")
