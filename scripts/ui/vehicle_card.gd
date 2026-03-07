class_name VehicleCard
extends Panel

signal clicked(vehicle: Vehicle)

@onready var status_label: Label = %StatusLabel

var vehicle

func setup(v):
	vehicle = v
	name = "Vehicle_%d_%s" % [
	vehicle.id,
	"Busy" if not vehicle.is_available else "Idle"
	]
	update_view()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if vehicle != null and vehicle.is_available:
			emit_signal("clicked", vehicle)

func update_view():
	if vehicle == null:
		return
		
	if vehicle.is_available:
		status_label.text = "aivailable"
		modulate = Color.WHITE
	else:
		status_label.text = "on tour: %s" % Constants.format_duration(vehicle.remaining_time)
		modulate = Color(0.4,0.4,0.4)
