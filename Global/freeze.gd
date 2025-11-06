extends Node

@onready var freeze_timer: Timer = Timer.new()

func _ready() -> void:
	add_child(freeze_timer)
	freeze_timer.ignore_time_scale = true
	freeze_timer.timeout.connect(func(): Engine.time_scale = 1.0)

func frame(time: float = 0.07):
	Engine.time_scale = 0.1
	freeze_timer.start(time)
