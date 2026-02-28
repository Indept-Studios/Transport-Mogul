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
