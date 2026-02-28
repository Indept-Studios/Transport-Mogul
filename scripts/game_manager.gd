extends Node


func _ready():
	Gamestate.contrac_service = Contract_Service.new()
	create_start_vehicle()
	Gamestate.contrac_service.generate_contracts_for(Gamestate.vehicles[0])

func _process(delta):
	for vehicle in Gamestate.vehicles:
		if not vehicle.is_available:
			vehicle.remaining_time -= delta
			if vehicle.remaining_time <= 0:
				finish_contract(vehicle)

#region Contract

func assign_contract(vehicle: Vehicle, contract: Contract):
	vehicle.is_available = false
	vehicle.current_contract = contract
	vehicle.remaining_time = contract.duration
	vehicle.available_contracts.clear()

func finish_contract(vehicle: Vehicle):
	if vehicle.current_contract == null:
		return
	add_money(vehicle.current_contract.reward)
	add_reputation(vehicle.current_contract.reputation_gain)

	vehicle.is_available = true
	vehicle.current_contract = null
	vehicle.remaining_time = 0.0

	Gamestate.contrac_service.generate_contracts_for(vehicle)

#endregion

#region Generally
func add_money(amount: int):
	Gamestate.add_money(amount)

func add_reputation(amount: int):
	Gamestate.add_reputation(amount)
#endregion

#region Vehicle
func add_vehicle(vehicle: Vehicle) -> void:
	Gamestate.add_vehicle(vehicle)
	Gamestate.contrac_service.generate_contracts_for(vehicle)

func buy_vehicle():
	if Gamestate.money < Constants.VEHICLE_COST:
		print("not enough money")
		return
	Gamestate.add_money(-Constants.VEHICLE_COST)
	add_vehicle(create_vehicle())

func create_vehicle() -> Vehicle:
	return Vehicle.new()

func create_start_vehicle():
	add_vehicle(create_vehicle())
#endregion

func _on_button_pressed():
	if Constants.DEBUGFLAG:
		add_vehicle(create_vehicle())
	else:
		buy_vehicle()
