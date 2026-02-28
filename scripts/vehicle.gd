class_name Vehicle
extends RefCounted

static var _next_id: int = 1

var id: int
var is_available: bool = true
var current_contract: Contract = null
var available_contracts: Array[Contract] = []
var remaining_time: float = 0.0

func _init():
	id = _next_id
	_next_id += 1

func to_dict() -> Dictionary:
	return {
		"state": {
			"is_available": is_available,
			"remaining_time": remaining_time,
		},
		"current_contract": current_contract.to_dict() if current_contract != null else null,
		"offers": available_contracts.map(func(c: Contract): return c.to_dict()),
	}

static func from_dict(dictonary: Dictionary) -> Vehicle:
	var vehicle := Vehicle.new()
	vehicle.is_available = bool(dictonary.get("is_available", true))
	vehicle.remaining_time = float(dictonary.get("remaining_time", 0.0))

	var cc = dictonary.get("current_contract", null)
	vehicle.current_contract = Contract.from_dict(cc) if (cc is Dictionary) else null

	vehicle.available_contracts.clear()
	var offers = dictonary.get("available_contracts", [])
	if offers is Array:
		for item in offers:
			if item is Dictionary:
				vehicle.available_contracts.append(Contract.from_dict(item))

	return vehicle
