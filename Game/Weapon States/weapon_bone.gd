extends WeaponState
class_name WeaponBone

@onready var animations: AnimatedSprite2D = $BoneAnimations
@onready var damage_dealer: Area2D = $DamageDealer
@onready var damage_dealer_shape: CollisionShape2D = $DamageDealer/Collision
@onready var break_particles: GPUParticles2D = $"../Break"

var durability: int = 4
var hit_this_swing: bool = false

func id() -> StringName:
	return &"Bone"

func enter():
	visible = true

func exit():
	visible = false
	damage_dealer_shape.disabled = true

func do_action():
	if animations.animation == "swing": return
	hit_this_swing = false
	animations.play("swing")
	damage_dealer_shape.disabled = false;

func physics_update(_delta: float) -> void:
	if not animations.is_playing():
		animations.play("idle")
		damage_dealer_shape.disabled = true;

func on_hit_other() -> void:
	if not hit_this_swing:
		durability -= 1
		if durability <= 0:
			do_break()
	hit_this_swing = true

func do_break():
	machine.current_state = null
	break_particles.emitting = true
