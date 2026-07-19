extends Node

var company_info := [CompanyLevel]
var contract_service: Contract_Service

func _ready():
	define_level()
	contract_service = Contract_Service.new()
	Gamestate.vehicles_changed.connect(_on_vehicles_changed)

func _process(delta):
	for vehicle in Gamestate.vehicles:
		if not vehicle.is_available:
			vehicle.remaining_time -= delta * TimeSystem.ticks_per_second
			if vehicle.remaining_time <= 0:
				finish_contract(vehicle)

#region Contract
func assign_contract(vehicle: Vehicle, contract: Contract):
	vehicle.is_available = false
	vehicle.current_contract = contract
	vehicle.remaining_time = contract.duration
	vehicle.available_contracts.clear()
	StatusLog.add(
	"Vehicle %d started %s contract (%s)" % [
	vehicle.id,
	contract.type,
	Constants.format_duration(contract.duration)
	],
	"info"
)

func finish_contract(vehicle: Vehicle):
	if vehicle.current_contract == null:
		return
	add_money(vehicle.current_contract.reward)
	add_reputation(vehicle.current_contract.reputation_gain)
	StatusLog.add(
	"Vehicle %d finished %s contract: +$%d +%d Rep" % [
	vehicle.id,
	vehicle.current_contract.type,
	vehicle.current_contract.reward,
	vehicle.current_contract.reputation_gain
	],
	"success")
	vehicle.is_available = true
	vehicle.current_contract = null
	vehicle.remaining_time = 0.0
	
	contract_service.generate_contracts_for(vehicle)

func _on_vehicles_changed():
	for vehicle in Gamestate.vehicles:
		if vehicle.current_contract != null and vehicle.remaining_time > 0.0:
			vehicle.is_available = false
		if vehicle.is_available and vehicle.available_contracts.size() < 3:
			contract_service.generate_contracts_for(vehicle)
#endregion

#region Generally
func add_money(amount: int):
	Gamestate.add_money(amount)

func add_reputation(amount: int):
	Gamestate.add_reputation(amount)

func start_new_game() -> void:
	StatusLog.clear()
	Gamestate.reset_game()
	TimeSystem.reset_time()
	add_vehicle(create_vehicle())
	contract_service.generate_contracts_for(Gamestate.vehicles[0])
	
func define_level() -> void:
	company_info = [
		CompanyLevel.new(0, 0, Vector2(10,30), 1.0, 1.0 ),
		CompanyLevel.new(1, 10, Vector2(120,900), 1.2, 1.1 ),
		CompanyLevel.new(2, 200, Vector2(900,3600), 1.5, 1.2 ),
		CompanyLevel.new(3, 500, Vector2(3600,14400), 1.8, 1.3 ),
		CompanyLevel.new(4, 2000, Vector2(14400,43200), 2.2, 1.4 ),
		CompanyLevel.new(5, 5000, Vector2(43200,86400), 2.8, 1.5 ),
		CompanyLevel.new(6, 10000, Vector2(86400,172800), 3.6, 1.6 ),
	]

func start_from_loaded_game() -> void:
	_on_vehicles_changed()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		SavegameManager.save_game()
		get_viewport().set_input_as_handled()
	#if event.is_action_pressed("load_game"):
		#if Gamestate.load_game():
			#start_from_loaded_game()
			#Engine.time_scale = 1.0
			#get_tree().paused = false
			#_on_vehicles_changed()
		#get_viewport().set_input_as_handled()
#endregion

#region Vehicle
func add_vehicle(vehicle: Vehicle) -> void:
	Gamestate.add_vehicle(vehicle)
	contract_service.generate_contracts_for(vehicle)

func buy_vehicle():
	if Gamestate.money < Constants.VEHICLE_COST:
		StatusLog.add("Not enough money to buy vehicle ($%d required)" % Constants.VEHICLE_COST, "warn")
		return
	Gamestate.add_money(-Constants.VEHICLE_COST)
	var v := create_vehicle()
	add_vehicle(v)
	StatusLog.add("Vehicle #%d bought: -$%d" % [v.id, Constants.VEHICLE_COST], "info")

func create_vehicle() -> Vehicle:
	return Vehicle.new()

func create_start_vehicle():
	add_vehicle(create_vehicle())
#endregion
