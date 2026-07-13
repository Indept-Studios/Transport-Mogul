extends Node

func save_game() -> bool:
	#Gamestate.last_save_unix = int(Time.get_unix_time_from_system())
	var data := to_dict()
	var json := JSON.stringify(data, "\t") 
	var file := FileAccess.open(Constants.SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not open save file for writing: " + Constants.SAVE_PATH)
		return false
	file.store_string(json)
	file.close()
	Gamestate.is_dirty = false
	StatusLog.add("Game successfully saved", "success")
	return true
	
func to_dict() -> Dictionary:
	var vehicles_dict := {}
	for v: Vehicle in Gamestate.vehicles:
		vehicles_dict[str(v.id)] = v.to_dict()
	return {
		"save_version": Constants.SAVE_VERSION,
		"date_time": get_datetime_dict(),
		"money": Gamestate.money,
		"reputation": Gamestate.reputation,
		"last_save_unix": Gamestate.last_save_unix,
		"vehicles": vehicles_dict,
		"tier_level": Gamestate.tier,
		"status_log": StatusLog.to_message_array(),
	}

func get_datetime_dict() -> Dictionary:
	return {
		"days": TimeSystem.date_time.days,
		"hours": TimeSystem.date_time.hours,
		"minutes": TimeSystem.date_time.minutes,
		"seconds": TimeSystem.date_time.seconds
	}

func get_save_list() -> Array:
	if not FileAccess.file_exists(Constants.SAVE_PATH):
		return []

	var file := FileAccess.open(Constants.SAVE_PATH, FileAccess.READ)
	if file == null:
		return []

	var text := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if not (parsed is Dictionary):
		return []

	var data: Dictionary = parsed
	var date_time: Dictionary = data.get("date_time", {})

	return [{
		"save_name": "Savegame",
		"days": int(date_time.get("days", 0)),
		"hours": int(date_time.get("hours", 8)),
		"minutes": int(date_time.get("minutes", 0)),
		"seconds": int(date_time.get("seconds",0)),
		"money": int(data.get("money", 0)),
		"reputation": int(data.get("reputation", 0)),
		"vehicles": (data.get("vehicles", {}) as Dictionary).size()
	}]
	
## TODO path integration for multiple savegames
func load_game(path: String) -> bool:
	if not FileAccess.file_exists(Constants.SAVE_PATH):
		return false

	var file := FileAccess.open(Constants.SAVE_PATH, FileAccess.READ)

	if file == null:
		return false

	var text := file.get_as_text()
	file.close()

	var data = JSON.parse_string(text)

	if data == null or not data is Dictionary:
		return false

	Gamestate.apply_save_data(data)

	StatusLog.add("Savegame loaded", "success")

	return true
