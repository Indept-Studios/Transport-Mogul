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
		"current_contract": current_contract.to_dict() if current_contract != null else {},
		"offers": available_contracts.map(func(c: Contract): return c.to_dict()),
	}

static func from_dict(d: Dictionary) -> Vehicle:
	var v := Vehicle.new()

	var state_v: Variant = d.get("state", {})
	if state_v is Dictionary:
		var state: Dictionary = state_v
		v.is_available = bool(state.get("is_available", true))
		v.remaining_time = float(state.get("remaining_time", 0.0))
	else:
		v.is_available = bool(d.get("is_available", true))
		v.remaining_time = float(d.get("remaining_time", 0.0))

	var cc_v: Variant = d.get("current_contract", null)
	if cc_v is Dictionary:
		v.current_contract = Contract.from_dict(cc_v as Dictionary)
	else:
		v.current_contract = null

	v.available_contracts.clear()
	var offers_v: Variant = d.get("offers", [])
	if offers_v is Array:
		for item_v in (offers_v as Array):
			if item_v is Dictionary:
				v.available_contracts.append(Contract.from_dict(item_v as Dictionary))

	return v
