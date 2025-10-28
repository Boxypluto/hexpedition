extends CharacterBody2D

@onready var animations: AnimatedSprite2D = $Animations

var flytimer = 0;
func _process(delta: float) -> void:
	velocity.x += (0.0-velocity.x)/(15.0);
	velocity.y += 3.5;
	if abs(velocity.y) > 450:
		velocity.y = 450*(velocity.y/abs(velocity.y));
	if Input.is_action_pressed("Right"):
		velocity.x += 10*(int(Input.is_action_pressed("Sprint")and velocity.y == 3.5)+1);
	if Input.is_action_pressed("Left"):
		velocity.x -= 10*(int(Input.is_action_pressed("Sprint")and velocity.y == 3.5)+1);
	if Input.is_action_pressed("Fly") and flytimer <= 0:
		flytimer = 0.5;
		velocity.y -= 550;
	if flytimer >0:
		flytimer -=delta;
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
	
	if Input.is_action_just_pressed("Fly") and not is_on_floor():
		animations.animation = "flap"
	
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
