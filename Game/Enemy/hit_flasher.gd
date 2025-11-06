extends Timer
class_name HitFlasher

@export var to_flash: CanvasItem

func _ready() -> void:
	one_shot = true
	wait_time = 0.1
	timeout.connect(func(): to_flash.material.set_shader_parameter("active", false))

func do_flash():
	stop()
	to_flash.material.set_shader_parameter("active", true)
	start()
