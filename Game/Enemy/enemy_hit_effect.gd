extends Sprite2D

func _ready() -> void:
	scale.x = randf_range(0.8, 1.2)
	scale.y = scale.x
	rotation = randf_range(0.0, TAU)

func _on_timer_timeout() -> void:
	queue_free()
