extends WeaponState
class_name WeaponBone

@onready var animations: AnimatedSprite2D = $BoneAnimations

func enter():
	visible = true

func exit():
	visible = false

func do_action():
	animations.play("swing")
	get_parent().get_parent().get_node("DamageDealer/Collision").disabled = false;
func physics_update(_delta: float) -> void:
	if not animations.is_playing():
		animations.play("idle")
		get_parent().get_parent().get_node("DamageDealer/Collision").disabled = true;
