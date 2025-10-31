extends WeaponState
class_name WeaponBone

@onready var animations: AnimatedSprite2D = $BoneAnimations
@onready var damage_dealer: DamageDealer = $DamageDealer
@onready var damage_dealer_shape: CollisionShape2D = $DamageDealer/Collision
@onready var break_particles: GPUParticles2D = $"../BreakBone"
@onready var break_effect: BreakEffect = $"../BreakEffect"

const START_DURABILITY = 3
var durability: int
var hit_this_swing: bool = false

func _ready() -> void:
	visible = false

func id() -> StringName:
	return &"Bone"

func enter():
	durability = START_DURABILITY
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
		Freeze.frame()
		durability -= 1
		if durability <= 0:
			damage_dealer.damage_last(50.0)
			break_effect.do_break()
			do_break()
	hit_this_swing = true

func do_break():
	machine.current_state = null
	break_particles.emitting = true
	Freeze.frame(0.1)
