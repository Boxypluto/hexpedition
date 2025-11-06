extends Node2D
class_name Spin

@export var speed: float = 32
var multiplier: float = 1.0

func _physics_process(delta: float) -> void:
	rotation += speed * delta * multiplier
