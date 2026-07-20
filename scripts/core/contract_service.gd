class_name Contract_Service extends Node

func generate_contracts_for(vehicle: Vehicle) -> void:
	vehicle.available_contracts.clear()
	var base_tier := Gamestate.calculate_reputation_tier()
	for i in 3:
		var offer_tier := _pick_offer_tier(base_tier)
		vehicle.available_contracts.append(generate_contract(offer_tier))
	vehicle.available_contracts.sort_custom(func(a: Contract, b: Contract) -> bool:
		if a.duration == b.duration:
			return a.reward < b.reward
		return a.duration < b.duration
	)

func _tier_duration_range(tier: int) -> Vector2:
	match tier:
		1: return Vector2(10.0, 30.0)
		2: return Vector2(120.0, 900.0)
		3: return Vector2(900.0, 3600.0)
		4: return Vector2(3600.0, 14400.0)
		5: return Vector2(14400.0, 43200.0)
		_: return Vector2(43200.0, 86400.0)
		
func _pick_offer_tier(base_tier: int) -> int:
	var roll := randf()
	if base_tier <= 1:
		return 1
	if roll < 0.70:
		return base_tier
	elif roll < 0.95:
		return base_tier - 1
	else:
		if Gamestate.vehicles.size() < 3:
			return base_tier
		return min(base_tier + 1, 6)

func _pick_contract_type(tier: int) -> String:
	var p_express := 0.10
	if tier >= 4:
		p_express = 0.15
	if randf() < p_express:
		return "express"
	return "standard"

func generate_contract(tier: int) -> Contract:
	var c := Contract.new()
	c.type = "standard"
	c.type = _pick_contract_type(tier)
	var reward_multiplier: float
	var reputation_multiplier: float

	match tier:
		1:
			reward_multiplier = 1.0
			reputation_multiplier = 1.0
		2:
			reward_multiplier = 1.2
			reputation_multiplier = 1.1
		3:
			reward_multiplier = 1.5
			reputation_multiplier = 1.2
		4:
			reward_multiplier = 1.8
			reputation_multiplier = 1.3
		5:
			reward_multiplier = 2.2
			reputation_multiplier = 1.4
		_:
			reward_multiplier = 2.8
			reputation_multiplier = 1.6

	var r := _tier_duration_range(tier)
	
	if c.type == "express":
		c.duration = max(10.0, c.duration * 0.6)
		reward_multiplier *= 1.35
		reputation_multiplier *= 0.75
	c.duration = round(randf_range(r.x, r.y))
	c.reward = int(sqrt(c.duration) * Constants.REWARD_MODIFYER * reward_multiplier)
	c.reputation_gain = max(1, int((c.duration / 60.0) * reputation_multiplier))

	return c
