extends WeaponState
class_name WeaponTail

@onready var animations: AnimatedSprite2D = $TailAnimations
@onready var damage_dealer: DamageDealer = $DamageDealer
@onready var damage_dealer_shape: CollisionShape2D = $DamageDealer/Collision
@onready var break_particles: GPUParticles2D = $"../BreakTail"
@onready var break_effect: BreakEffect = $"../BreakEffect"
@onready var damage_interval: Timer = $DamageInterval

const START_DURABILITY = 3
var durability: int
var hit_this_swing: bool = false
var marked_for_breaking: bool = false

func _ready() -> void:
	visible = false

func id() -> StringName:
	return &"Tail"

func enter():
	marked_for_breaking = false
	durability = START_DURABILITY
	visible = true

func exit():
	break_particles.emitting = true
	visible = false
	damage_dealer_shape.disabled = true
	marked_for_breaking = false

func do_action():
	if animations.animation == "swing": return
	hit_this_swing = false
	animations.play("swing")
	damage_dealer_shape.disabled = false
	damage_interval.start()

func physics_update(_delta: float) -> void:
	if not animations.is_playing():
		animations.play("idle")
		damage_dealer_shape.disabled = true
		damage_interval.stop()
		if marked_for_breaking:
			break_effect.do_break()
			do_break()

func on_hit_other() -> void:
	if not hit_this_swing:
		Freeze.frame()
		durability -= 1
		if durability <= 0:
			marked_for_breaking = true
	hit_this_swing = true

func do_break():
	machine.current_state = null
	Freeze.frame(0.1)

func on_damage_interval() -> void:
	if animations.is_playing() and animations.animation == "swing":
		damage_dealer_shape.disabled = false
		await get_tree().create_timer(damage_interval.wait_time / 2.0).timeout
		damage_dealer_shape.disabled = true
