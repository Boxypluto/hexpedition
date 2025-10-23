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
	if not animations.is_playing():
		animations.play()
	# Flip the sprite based on movement
	if sign(horizontal_input) == 1:
		animations.flip_h = false
	if sign(horizontal_input) == -1:
		animations.flip_h = true
	# Idle if there's NO INPUT or if the player is NOT ON FLOOR
	# *This will change later*, when I make more animations
	if horizontal_input == 0.0 or not is_on_floor():
		animations.animation = "idle"
	else:
		animations.animation = "walk"
