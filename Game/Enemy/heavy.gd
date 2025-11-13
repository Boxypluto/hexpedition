extends CharacterBody2D

var health = 350;
var active = false;
var last_known_pos = Vector2(0,0);
var search_timer = 0;
var hitTimer = 0;
var damageD = 25;
var stopTimer = 0;
var moveTimer = 0.0;
var damageTimer = 0.0;
var makingTheJump = false;
var knockback_multiplier: float = 8.0

@onready var steer_left: RayCast2D = $SteeringRays/Left
@onready var steer_right: RayCast2D = $SteeringRays/Right
@onready var hit_flasher: HitFlasher = $HitFlasher

const bone = preload("res://Game/Interactive Objects/devil_tail.tscn")
func _process(delta: float) -> void:
	var limit_left: bool = steer_left.is_colliding()
	var limit_right: bool = steer_right.is_colliding()
	velocity.x = lerp(velocity.x, 0.0, 0.06666)
	velocity.y += 500.0*delta;
	velocity.y = clamp(velocity.y, -250.0, 250.0);
	if GlobalVariables.currentLevel.has_node("Player"):
		var target= to_local(GlobalVariables.currentLevel.get_node("Player").global_position);
		if target.length() > 300.0:
			target = target.normalized() * 300.0
		if is_nan(target.x) or is_nan(target.y):
			target = Vector2(0,0);
		$RayCast2D.target_position = target;
		$RayCast2D.force_raycast_update();
		if $RayCast2D.get_collider() == GlobalVariables.currentLevel.get_node("Player"):
			search_timer = 5;
			last_known_pos = GlobalVariables.currentLevel.get_node("Player").global_position;
			active = true;
		else:
			active = false;
	else:
		active = false;
	if active:
		stopTimer -= delta;
		damageTimer -= delta;
		moveTimer = lerp(moveTimer, 1.0, 0.015);
		if stopTimer > 7.2:
			velocity.x = 0;
		elif stopTimer > 7.1:
			stopTimer = 7.1;
			moveTimer = 5.0;
			damageTimer = 1.5;
			velocity.y -= 1000.0;
		else:
			if abs(velocity.x) < 1 and is_on_floor():
				velocity.y -= 100.0;
				makingTheJump = false;
			if GlobalVariables.currentLevel.get_node("Player").global_position.x > global_position.x:
				$BigFallDetector.position.x = 5;
				$BigFallDetector.force_raycast_update();
				if $BigFallDetector.is_colliding() or moveTimer > 1:
					velocity.x += 2*moveTimer;
			elif GlobalVariables.currentLevel.get_node("Player").global_position.x < global_position.x:
				$BigFallDetector.position.x = -5;
				$BigFallDetector.force_raycast_update();
				if $BigFallDetector.is_colliding() or moveTimer > 1:
					velocity.x -= 2*moveTimer;
			if GlobalVariables.currentLevel.get_node("Player").global_position.distance_to(global_position)<75 and not stopTimer > 0:
				stopTimer = 7.7;
	else:
		if search_timer > 0:
			search_timer -= delta;
			if abs(velocity.x) < 5 and is_on_floor() and search_timer > 3:
				velocity.y -= 20.0;
			if last_known_pos.x+randi_range(-20,20) > global_position.x:
				$BigFallDetector.position.x = 5;
				$BigFallDetector.force_raycast_update();
				if $BigFallDetector.is_colliding():
					velocity.x += search_timer
			elif last_known_pos.x+randi_range(-20,20) < global_position.x:
				$BigFallDetector.position.x = -5;
				$BigFallDetector.force_raycast_update();
				if $BigFallDetector.is_colliding():
					velocity.x += -search_timer;
	# Enemy Seperation Steering
	if (velocity.x > 0 and limit_right) or (velocity.x < 0 and limit_left):
		velocity.x *= 0.8
	move_and_slide();
	if hitTimer > 0:
		hitTimer-= delta;
	if health < 0 or global_position.y > 700 or global_position.y < -4000:
		if GlobalVariables.currentLevel.has_node("Player"):
			GlobalVariables.currentLevel.get_node("Player").health += 2.5;
			#if DropRandomiser.random_chance(4, 0.3):
			var newbone = bone.instantiate();
			newbone.global_position = global_position;
			newbone.linear_velocity = Vector2(randi_range(-50,50),-100);
			newbone.angular_velocity = randi_range(-20,20);
			GlobalVariables.currentLevel.add_child(newbone);
			queue_free();
	if active:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider == GlobalVariables.currentLevel.get_node("Player"):
				var direction = (GlobalVariables.currentLevel.get_node("Player").global_position - global_position).normalized()
				if damageTimer > 0:
					damageD = 30;
					velocity.y -= 500.0;
				else:
					damageD = 15;
				GlobalVariables.currentLevel.get_node("Player").damage(direction * 110, damageD)

func damage(force: Vector2, h: int):
	velocity.x += force.x * knockback_multiplier
	velocity.y -= 4.0;
	if hitTimer < 0.24:
		health -= h
		hit_flasher.do_flash()
	hitTimer = 0.25;
