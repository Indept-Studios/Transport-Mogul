class_name Contract_Service
extends Node

func generate_contracts_for(vehicle: Vehicle):
	vehicle.available_contracts.clear()
	for i in 3:
		vehicle.available_contracts.append(generate_contract(Gamestate.reputation))

func generate_contract(reputation: int) -> Contract:
	var contract = Contract.new()
	contract.duration = randf_range(Constants.MIN_DURATION, Constants.MAX_DURATION) + reputation * Constants.REPUTATION_MODIFYER
	contract.reward = int(contract.duration * Constants.REWARD_MODIFYER + reputation * 2)
	contract.reputation_gain = int(contract.duration / 5)
	return contract
