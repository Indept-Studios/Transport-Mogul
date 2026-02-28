extends Node

signal vehicles_changed
signal resources_changed

var contrac_service: Contract_Service = null
var money: int = 500
var reputation: int = 0
var vehicles: Array = []

func add_vehicle(vehicle: Vehicle):
	vehicles.append(vehicle)
	emit_signal("vehicles_changed")

func add_money(amount: int):
	money += amount
	emit_signal("resources_changed")

func add_reputation(amount: int):
	reputation += amount
	emit_signal("resources_changed")
