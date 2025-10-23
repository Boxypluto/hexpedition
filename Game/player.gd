extends CharacterBody2D

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
	move_and_slide();
