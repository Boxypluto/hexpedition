extends Node2D

@export var current_state: WeaponState:
	set(new):
		if current_state != null:
			current_state.exit()
		current_state = new
		new.enter()
@onready var animations: AnimatedSprite2D = $"../Animations"

func _process(_delta: float) -> void:
	var filp: int = -1 if animations.flip_h else 1
	scale.x = filp

func do_action():
	if current_state == null: return
	current_state.do_action()

func _physics_process(delta: float) -> void:
	if current_state == null: return
	current_state.physics_update(delta)
