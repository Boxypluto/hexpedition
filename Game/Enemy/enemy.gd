extends CharacterBody2D

var health = 50;
var active = false;
var last_known_pos = Vector2(0,0);
var search_timer = 0;
var hitTimer = 0;
func _process(delta: float) -> void:
	
	velocity.x += (0.0-velocity.x)/(15.0);
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
		if GlobalVariables.currentLevel.get_node("Player").global_position.x > global_position.x:
			velocity.x += 4
		elif GlobalVariables.currentLevel.get_node("Player").global_position.x < global_position.x:
			velocity.x += -4;
	else:
		if search_timer > 0:
			search_timer -= delta;
			if abs(velocity.x) < 20 and is_on_floor() and search_timer > 3:
				velocity.y -= 150;
			if last_known_pos.x+randi_range(-20,20) > global_position.x:
				velocity.x += search_timer
			elif last_known_pos.x+randi_range(-20,20) < global_position.x:
				velocity.x += -search_timer;
		pass
		#IDLE ANIMATION
	move_and_slide();
	if hitTimer > 0:
		hitTimer-= delta;
		modulate= Color.html("#ffaaaa");
	else:
		modulate= Color.html("#ffffff");
		health += 5*delta;
	if health < 0 or global_position.y > 700:
		queue_free();
	if active:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider == GlobalVariables.currentLevel.get_node("Player"):
				var direction = (GlobalVariables.currentLevel.get_node("Player").global_position - global_position).normalized()
				GlobalVariables.currentLevel.get_node("Player").damage(direction * 50, 5)
func damage(force: Vector2, h: int):
	velocity.x += force.x
	velocity.y -= 8;
	if hitTimer < 0.24:
		health -= h
	hitTimer = 0.25;
