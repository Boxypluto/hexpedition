extends Sprite2D

func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	scale.x = randf_range(0.8, 1.2)
	scale.y = scale.x
	rotation = randf_range(0.0, TAU)
	await get_tree().create_timer(0.05).timeout
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT

func _on_timer_timeout() -> void:
	queue_free()
