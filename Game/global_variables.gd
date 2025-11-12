extends Node
var currentLevel;
var firstSelected;
var paused = false;
var timeScale = 1.0;
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
func _process(_delta) -> void:
	if Input.is_action_just_pressed("Pause"):
		paused = !paused;
		get_tree().paused = paused;
