extends CanvasLayer

signal on_transition_finished

@export_enum("0.5", "1.0", "2.0") var transition_speed: = 1
	
@onready var color_rect : ColorRect = %ColorRect
@onready var animation_player = %AnimationPlayer

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	animation_player.speed_scale = transition_speed

func _on_animation_finished(anim_name):
	if anim_name == "FADE_TO_BLACK":
		on_transition_finished.emit()
		animation_player.play("FADE_TO_NORMAL")
	elif anim_name == "FADE_TO_NORMAL":
		color_rect.visible = false

func play_transistion():
	color_rect.visible = true
	animation_player.play("FADE_TO_BLACK")
