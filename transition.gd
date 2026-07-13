extends CanvasLayer

signal on_transition_finished

@onready var color_rect : ColorRect = %ColorRect
@onready var animation_player = %AnimationPlayer

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "FADE_TO_BLACK":
		on_transition_finished.emit()
		animation_player.play("FADE_TO_NORMAL")
	elif anim_name == "FADE_TO_NORMAL":
		color_rect.visible = false
	

func play_transistion():
	color_rect.visible = true
	animation_player.play("FADE_TO_BLACK")
