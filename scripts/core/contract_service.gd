class_name Contract_Service
extends Node

func generate_contracts_for(vehicle: Vehicle) -> void:
	vehicle.available_contracts.clear()
	var base_tier := Gamestate.get_reputation_tier()
	for i in 3:
		var offer_tier := _pick_offer_tier(base_tier)
		vehicle.available_contracts.append(generate_contract(offer_tier))

func _tier_duration_range(tier: int) -> Vector2:
	match tier:
		1: return Vector2(10.0, 180.0)
		2: return Vector2(180.0, 900.0)
		3: return Vector2(900.0, 3600.0)
		4: return Vector2(3600.0, 14400.0)
		5: return Vector2(14400.0, 43200.0)
		_: return Vector2(43200.0, 86400.0)
		
func _pick_offer_tier(base_tier: int) -> int:
	var roll := randf()

	if base_tier <= 1:
		return 1

	if roll < 0.60:
		return base_tier
	elif roll < 0.90:
		return base_tier - 1
	else:
		return min(base_tier + 1, 6)

func generate_contract(tier: int) -> Contract:
	var c := Contract.new()

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
	c.duration = round(randf_range(r.x, r.y))

	c.reward = int(c.duration * Constants.REWARD_MODIFYER * reward_multiplier)
	c.reputation_gain = int((c.duration / 60.0) * reputation_multiplier)

	return c
