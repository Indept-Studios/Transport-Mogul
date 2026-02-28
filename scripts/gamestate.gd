extends Node

signal vehicles_changed
signal resources_changed

const SAVE_PATH := "user://savegame.json"
const SAVE_VERSION := 1

var contrac_service: Contract_Service = null
var money: int = 500
var reputation: int = 0
var vehicles: Array = []

func add_vehicle(vehicle: Vehicle):
	vehicles.append(vehicle)
	emit_signal("vehicles_changed")

func add_money(amount: int):
	money += amount
	emit_signal("resources_changed")

func add_reputation(amount: int):
	reputation += amount
	emit_signal("resources_changed")
	
func to_dict() -> Dictionary:
	var vehicles_dict := {}
	for v: Vehicle in vehicles:
		vehicles_dict[str(v.id)] = v.to_dict()
	return {
		"save_version": SAVE_VERSION,
		"money": money,
		"reputation": reputation,
		"vehicles": vehicles_dict,
	}

func save_game() -> bool:
	var data := to_dict()
	var json := JSON.stringify(data, "\t") 
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not open save file for writing: " + SAVE_PATH)
		return false
	file.store_string(json)
	file.close()
	return true

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not open save file for reading: " + SAVE_PATH)
		return false

	var text := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if parsed == null or not (parsed is Dictionary):
		push_error("Save file is not valid JSON Dictionary")
		return false

	var dictonary: Dictionary = parsed
	var ver := int(dictonary.get("save_version", 0))
	if ver != SAVE_VERSION:
		push_warning("Save version mismatch. Found %d expected %d" % [ver, SAVE_VERSION])

	money = int(dictonary.get("money", 500))
	reputation = int(dictonary.get("reputation", 0))
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
	return true
