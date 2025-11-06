extends CharacterBody2D

var health = 50;
var active = false;
var last_known_pos = Vector2(0,0);
var search_timer = 0;
var hitTimer = 0;
var move_x = 0.0;

var knockback_multiplier: float = 8.0

@onready var steer_left: RayCast2D = $SteeringRays/Left
@onready var steer_right: RayCast2D = $SteeringRays/Right
@onready var animations: AnimatedSprite2D = $Animations

const feather = preload("res://Game/Interactive Objects/harpy_feather.tscn")
func _process(delta: float) -> void:
	var limit_left: bool = steer_left.is_colliding()
	var limit_right: bool = steer_right.is_colliding()
	move_x = lerp(float(move_x), 0.0, 1.0 / 55.0)
	velocity.x = lerp(velocity.x, move_x, 1.0 / 200.0)
	velocity.y += 500*delta;
	velocity.y = clamp(velocity.y, -250, 250);
	velocity.x = clamp(velocity.x, -250, 250);
	if GlobalVariables.currentLevel.has_node("Player"):
		var target= to_local(GlobalVariables.currentLevel.get_node("Player").global_position);
		if target.length() > 200:
			target = target.normalized() * 200
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
		animations.animation = "Flap"
		if (velocity.y > 50 and GlobalVariables.currentLevel.get_node("Player").global_position.distance_to(global_position)>100):
			if GlobalVariables.currentLevel.get_node("Player").global_position.y-50 < global_position.y:
				velocity.y -= 300;
		elif velocity.y > 50:
			if GlobalVariables.currentLevel.get_node("Player").global_position.y < global_position.y:
				velocity.y -= 300;
		if is_on_floor():
			velocity.y -= 300;
		if GlobalVariables.currentLevel.get_node("Player").global_position.x > global_position.x:
			move_x = 150;
		elif GlobalVariables.currentLevel.get_node("Player").global_position.x < global_position.x:
			move_x = -150;
	else:
		if !is_on_ceiling():
			animations.animation = "Flap"
			if (velocity.y > 50):
				velocity.y -= 300;
		else:
			animations.animation = "Hang"
			velocity = Vector2(0,0);
		pass
	
	# Flipping
	if velocity.x > 0:
		animations.flip_h = true
	if velocity.x < 0:
		animations.flip_h = false
	
	# Enemy Seperation Steering
	if (velocity.x > 0 and limit_right) or (velocity.x < 0 and limit_left):
		velocity.x *= 0.8
			
		#IDLE ANIMATION
		velocity.x = 0;
	move_and_slide();
	if hitTimer > 0:
		hitTimer-= delta;
		modulate= Color.html("#ffaaaa");
	else:
		modulate= Color.html("#ffffff");
	if health < 0 or global_position.y > 700 or global_position.y < -4000:
		if GlobalVariables.currentLevel.has_node("Player"):
			GlobalVariables.currentLevel.get_node("Player").health += 5;
			#if DropRandomiser.random_chance(4, 0.3):
			var newfeather = feather.instantiate();
			newfeather.global_position = global_position;
			newfeather.linear_velocity = Vector2(randi_range(-50,50),-100);
			newfeather.angular_velocity = randi_range(-20,20);
			GlobalVariables.currentLevel.add_child(newfeather);
			queue_free();
	if active:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider == GlobalVariables.currentLevel.get_node("Player"):
				var direction = (GlobalVariables.currentLevel.get_node("Player").global_position - global_position).normalized()
				GlobalVariables.currentLevel.get_node("Player").damage(direction * 50, 7)
func damage(force: Vector2, h: int):
	velocity.x += force.x * knockback_multiplier
	velocity.y -= 4;
	if hitTimer < 0.24:
		health -= h
	hitTimer = 0.25;
