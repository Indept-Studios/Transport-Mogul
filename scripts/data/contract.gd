class_name Contract
extends RefCounted

var duration: float = 0.0
var reward: int = 0
var reputation_gain: int = 0
var contract_tier: int  = Gamestate.get_reputation_tier()

func to_dict() -> Dictionary:
	return {
		"duration": duration,
		"reward": reward,
		"reputation_gain": reputation_gain,
	}

static func from_dict(dictonary: Dictionary) -> Contract:
	var contract := Contract.new()
	contract.duration = float(dictonary.get("duration", 0.0))
	contract.reward = int(dictonary.get("reward", 0))
	contract.reputation_gain = int(dictonary.get("reputation_gain", 0))
	return contract
