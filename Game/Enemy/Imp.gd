extends CharacterBody2D

var health = 50;
var active = false;
var last_known_pos = Vector2(0,0);
var search_timer = 0;
var hitTimer = 0;
var makingTheJump = false;
var knockback_multiplier: float = 8.0

@onready var steer_left: RayCast2D = $SteeringRays/Left
@onready var steer_right: RayCast2D = $SteeringRays/Right
@onready var hit_flasher: HitFlasher = $HitFlasher

const bone = preload("res://Game/Interactive Objects/bone.tscn")
func _process(delta: float) -> void:
	
	var limit_left: bool = steer_left.is_colliding()
	var limit_right: bool = steer_right.is_colliding()
	if global_position.x == NAN:
		global_position = Vector2(0,0)
	velocity.x = lerp(velocity.x, 0.0, 1.0 / 15.0)
	velocity.y += 500*delta;
	if abs(velocity.y) > 250:
		velocity.y = 250*(velocity.y/abs(velocity.y));
	if GlobalVariables.currentLevel.has_node("Player"):
		var target= to_local(GlobalVariables.currentLevel.get_node("Player").global_position);
		if target.length() > 300:
			target = target.normalized() * 300
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
		if abs(velocity.x) < 20 and is_on_floor():
			velocity.y -= 150;
			makingTheJump = false;
		if GlobalVariables.currentLevel.get_node("Player").global_position.x > global_position.x:
			$BigFallDetector.position.x = 15;
			$BigFallDetector.force_raycast_update();
			if !makingTheJump:
				makingTheJump = (GlobalVariables.currentLevel.get_node("Player").global_position.y > global_position.y and (abs(global_position.y-GlobalVariables.currentLevel.get_node("Player").global_position.y) > 140));
			if $BigFallDetector.is_colliding() or makingTheJump:
				velocity.x += 4
		elif GlobalVariables.currentLevel.get_node("Player").global_position.x < global_position.x:
			$BigFallDetector.position.x = -15;
			$BigFallDetector.force_raycast_update();
			if !makingTheJump:
				makingTheJump = (GlobalVariables.currentLevel.get_node("Player").global_position.y > global_position.y and (abs(global_position.y-GlobalVariables.currentLevel.get_node("Player").global_position.y) > 140));
			if $BigFallDetector.is_colliding() or makingTheJump:
				velocity.x -= 4
	else:
		if search_timer > 0:
			search_timer -= delta;
			if abs(velocity.x) < 20 and is_on_floor() and search_timer > 3:
				velocity.y -= 150;
			if last_known_pos.x+randi_range(-20,20) > global_position.x:
				$BigFallDetector.position.x = 15;
				$BigFallDetector.force_raycast_update();
				if $BigFallDetector.is_colliding():
					velocity.x += search_timer
			elif last_known_pos.x+randi_range(-20,20) < global_position.x:
				$BigFallDetector.position.x = -15;
				$BigFallDetector.force_raycast_update();
				if $BigFallDetector.is_colliding():
					velocity.x += -search_timer;
		pass
		
	# Enemy Seperation Steering
	if (velocity.x > 0 and limit_right) or (velocity.x < 0 and limit_left):
		velocity.x *= 0.8
			
		#IDLE ANIMATION
		velocity.x = 0;
	move_and_slide();
	if hitTimer > 0:
		hitTimer-= delta;
	if health < 0 or global_position.y > 700 or global_position.y < -4000:
		if GlobalVariables.currentLevel.has_node("Player"):
			GlobalVariables.currentLevel.get_node("Player").health += 10;
			if DropRandomiser.random_chance(4, 0.3):
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
				GlobalVariables.currentLevel.get_node("Player").damage(direction * 50, 5)

func damage(force: Vector2, h: int):
	velocity.x += force.x * knockback_multiplier
	velocity.y -= 4;
	if hitTimer < 0.24:
		health -= h
		hit_flasher.do_flash()
	hitTimer = 0.25;
