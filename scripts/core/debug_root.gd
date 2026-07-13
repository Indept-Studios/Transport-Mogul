extends Control

func _on_buy_button_debug_pressed():
	if Constants.DEBUGFLAG:
		GameManager.add_vehicle(GameManager.create_vehicle())
	else:
		GameManager.buy_vehicle()
