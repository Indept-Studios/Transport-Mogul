extends Control

@onready var time_label: Label = %TimeLabel

func _ready():
	TimeSystem.updated.connect(update_clock)
	update_clock(TimeSystem.date_time)

func update_clock(date_time: DateTime) -> void:
	time_label.text = "%02d:%02d:%02d" % [
		date_time.hours,
		date_time.minutes,
		date_time.seconds
	]
