extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $Animations
@onready var weapon_machine: Node2D = $WeaponStates

# flytimer controls the time between each flap
# stamina controls how many flaps until out
# staminaRegen is a control timer to regen stamina
var flytimer = 0;
var stamina = 8;
var staminaRegen = 0;

func _process(delta: float) -> void:
	# constant velocity: velocity.x is smoothed towards zero, velocity.y is gravity
	velocity.x += (0.0-velocity.x)/(15.0);
	velocity.y += 3.5;
	
	# Max cap on velocity
	if abs(velocity.y) > 250:
		velocity.y = 250*(velocity.y/abs(velocity.y));
		
	# Input control
	if Input.is_action_pressed("Right"):
		velocity.x += 5*(int(Input.is_action_pressed("Sprint")and velocity.y == 3.5)+1);
	if Input.is_action_pressed("Left"):
		velocity.x -= 5*(int(Input.is_action_pressed("Sprint")and velocity.y == 3.5)+1);
	if Input.is_action_pressed("Fly") and flytimer <= 0 and stamina > 0:
		flytimer = 0.5;
		velocity.y -= 350;
		stamina -= 1;
		staminaRegen = 2;
		animations.play("flap")
	
	if Input.is_action_just_pressed("Use"):
		weapon_machine.do_action()
	
	# Timer control, regen and time between each flap
	if flytimer >0:
		flytimer -=delta;
	if staminaRegen < 0:
		staminaRegen = 1;
		stamina += 1
	else:
		staminaRegen -=delta;
		
	# Animate the player (below)
	animate()
	move_and_slide();

func animate():
	# Save horizontal input
	var horizontal_input: float = Input.get_axis("Left", "Right")
	
	# Always play animations (for now)
	if not animations.is_playing() and animations.animation != "flap":
		animations.play()
		
	# Flip the sprite based on movement
	if sign(horizontal_input) == 1:
		animations.flip_h = false
	if sign(horizontal_input) == -1:
		animations.flip_h = true
		
	# Idle if there's NO INPUT or if the player is NOT ON FLOOR
	# *This will change later*, when I make more animations
	if is_on_floor():
		if horizontal_input == 0.0:
			animations.animation = "idle"
		else:
			animations.animation = "walk"
	else:
		if not (animations.animation == "flap" and animations.is_playing()):
			if velocity.y < 0:
				animations.animation = "jump"
			else:
				animations.animation = "fall"
