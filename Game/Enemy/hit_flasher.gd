extends Timer
class_name HitFlasher

@export var to_flash: CanvasItem
var sprite: Sprite2D

const HIT_EFFECT = preload("res://assets/enemies/hit_effect.png")

func _ready() -> void:
	one_shot = true
	wait_time = 0.1
	timeout.connect(func():
		to_flash.material.set_shader_parameter("active", false)
		sprite.visible = false
		)
	sprite = Sprite2D.new()
	sprite.texture = HIT_EFFECT
	get_parent().add_child.call_deferred(sprite)
	sprite.visible = false

func do_flash():
	stop()
	sprite.visible = true
	to_flash.material.set_shader_parameter("active", true)
	start()
