extends Node

signal updated(date_time: DateTime)

@export var ticks_per_second: int = 6

var date_time := DateTime.new()

func _process(delta):
	date_time.increase_by_sec(delta * ticks_per_second)
	updated.emit(date_time)

func reset_time(d:= 0,h := 8, m := 0, s := 0):
	date_time.set_time(d, h, m, s)
	updated.emit(date_time)
