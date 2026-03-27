extends Node

signal vehicles_changed
signal resources_changed
signal tier_changed

var contrac_service: Contract_Service = null
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
	emit_signal("resources_changed")

func get_reputation_tier() -> int:
	var base_tier: int
	
	if Gamestate.reputation < 10:
		base_tier = 1
	elif Gamestate.reputation < 200:
		base_tier = 2
	elif Gamestate.reputation < 500:
		base_tier = 3
	elif Gamestate.reputation < 2000:
		base_tier = 4
	elif Gamestate.reputation < 5000:
		base_tier = 5
	else:
		base_tier = 6
	emit_signal("tier_changed")
	return base_tier

	
func reset_game() -> void:
	money = Constants.START_MONEY
	reputation = Constants.START_REPUTATION
	vehicles.clear()
	Vehicle._next_id = 1
	emit_signal("resources_changed")
	emit_signal("vehicles_changed")

func load_game() -> bool:
	if not FileAccess.file_exists(Constants.SAVE_PATH):
		return false

	var file := FileAccess.open(Constants.SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not open save file for reading: " + Constants.SAVE_PATH)
		return false

	var text := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if parsed == null or not (parsed is Dictionary):
		push_error("Save file is not valid JSON Dictionary")
		return false

	var dictonary: Dictionary = parsed
	var ver := int(dictonary.get("save_version", 0))
	if ver != Constants.SAVE_VERSION:
		push_warning("Save version mismatch. Found %d expected %d" % [ver, Constants.SAVE_VERSION])
	last_save_unix = int(dictonary.get("last_save_unix", 0))
	is_dirty = false
	money = int(dictonary.get("money", 500))
	reputation = int(dictonary.get("reputation", 0))
	tier = int(dictonary.get("tier_level", 0))
	vehicles.clear()

	var vs: Variant = dictonary.get("vehicles", null)
	var max_id: int = 0

	if typeof(vs) != TYPE_DICTIONARY:
		return false

	var vdict: Dictionary = vs as Dictionary

	for key in vdict.keys():
		var item_variant: Variant = vdict.get(key)

		if item_variant is Dictionary:
			var vehicle_dict: Dictionary = item_variant
			var v: Vehicle = Vehicle.from_dict(vehicle_dict)

			v.id = int(str(key))
			vehicles.append(v)
			max_id = max(max_id, v.id)

	vehicles.sort_custom(func(a: Vehicle, b: Vehicle) -> bool:
		return a.id < b.id
	)

	for v in vehicles:
		if v.current_contract != null and v.remaining_time > 0.0:
			v.is_available = false
		elif v.current_contract == null:
			v.is_available = true

	if max_id > 0:
		Vehicle._next_id = max_id + 1
	
	emit_signal("resources_changed")
	emit_signal("vehicles_changed")
	StatusLog.add("Savegame loaded", "success")
	return true
