extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $Animations
@onready var weapon_machine: WeaponStateMachine = $WeaponStates

# flytimer controls the time between each flap
# stamina controls how many flaps until out
# staminaRegen is a control timer to regen stamina
# invenotry is a string list, can create weapons from there
var flytimer = 0;
var stamina = 8;
var staminaRegen = 0;
var inventory = [];
var health = 100;
var hitTimer = 0;

const PICKUP_DISTANCE: float = 32.0

func _process(delta: float) -> void:
	if health < 0 or global_position.y > 700:
		get_parent().get_node("deathCam").zoom = $Camera2D.zoom;
		get_parent().get_node("deathCam").global_position = $Camera2D.global_position;
		get_parent().get_node("deathCam").enabled = true;
		queue_free();
	elif health>100:
		health = 100;
	# constant velocity: velocity.x is smoothed towards zero, velocity.y is gravity
	velocity.x += (0.0-velocity.x)/(15.0);
	velocity.y += 500*delta;
	
	# Max cap on velocity
	if abs(velocity.y) > 250:
		velocity.y = 250*(velocity.y/abs(velocity.y));
		
	# Input control
	if Input.is_action_pressed("Right"):
		velocity.x += 5*(int(Input.is_action_pressed("Sprint")and is_on_floor())+1);
	if Input.is_action_pressed("Left"):
		velocity.x -= 5*(int(Input.is_action_pressed("Sprint")and is_on_floor())+1);
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
	
	if Input.is_action_just_pressed("Attack"):
		$WeaponStates.do_action()
	if hitTimer > 0:
		hitTimer-= delta;
		modulate= Color.html("#ffaaaa");
	else:
		modulate= Color.html("#ffffff");
		health += 5*delta;
	pickupable_process()
	
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
func damage(force: Vector2, h: int):
	velocity.x += force.x
	velocity.y -= 8;
	if hitTimer < 0.24:
		health -= h
	hitTimer = 0.25;

func pickupable_process() -> void:
	var closest: PickupableWeapon = null
	var closest_distance: float = INF
	for pickupable in Registry.pickupables:
		pickupable.highlighted = false
		var distance: float = pickupable.global_position.distance_to(global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest = pickupable
	if closest:
		if closest_distance > PICKUP_DISTANCE:
			closest = null
		else:
			closest.highlighted = true
	
	if Input.is_action_just_pressed("PickUp") and closest != null:
		weapon_machine.swap_to_id(closest.do_pickup())
