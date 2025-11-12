extends Node2D
class_name WeaponStateMachine

@export var current_state: WeaponState:
	set(new):
		if current_state != null:
			current_state.exit()
		current_state = new
		if new != null:
			new.enter()
@onready var animations: AnimatedSprite2D = $"../Animations"

@onready var player: Player = $".."

func swap_to_id(id: StringName):
	for state in get_children():
		if state is not WeaponState: continue
		state = state as WeaponState
		if state.id() == id:
			current_state = state

func _process(_delta: float) -> void:
	var filp: int = -1 if animations.flip_h else 1
	scale.x = filp

func do_action():
	if current_state == null: 
		weaponless_slash()
		return
	current_state.do_action()

func _physics_process(delta: float) -> void:
	weaponless_process()
	if current_state == null:
		player.duability_indicator.self_modulate.a = 0.0
		return
	if current_state is WeaponStateFeather:
		player.duability_indicator.self_modulate.a = 0.0
	else:
		player.duability_indicator.durability = current_state.durability
	current_state.physics_update(delta)

# WEAPON LESS STATE --- DO NOT ADD OTHER STATES TO THIS FILE! INSTEAD ADD THEM AS CHILD NOTED WHICH INHERIT "WeaponState"!
# THEN SETUP THEIR ID TO MATCH THE ID OF THE PICKUPABLE THEY CONNECT TO!

@onready var weaponless_animation: AnimatedSprite2D = $Weaponless/WeaponlessAnimation
@onready var weaponless_damage_dealer: DamageDealer = $Weaponless/DamageDealer
@onready var weaponless_collision: CollisionShape2D = $Weaponless/DamageDealer/Collision

func weaponless_slash():
	weaponless_animation.play("Swing")
	weaponless_collision.disabled = false

func weaponless_process():
	if weaponless_animation.animation == "Swing" and not weaponless_animation.is_playing():
		weaponless_animation.animation = "None"
	
	if weaponless_animation.animation == "None" and not weaponless_collision.disabled:
		weaponless_collision.disabled = true
