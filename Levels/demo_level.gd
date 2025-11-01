extends Node2D
var souls = 0;
func _ready() -> void:
	GlobalVariables.currentLevel = self;
	souls = $TotalEnemy.get_child_count();
func _process(delta: float) -> void:
	if !has_node("Player"):
		$deathCam.zoom.x += (1.5-$deathCam.zoom.x)/(50000.0*delta);
		$deathCam.zoom.y = $deathCam.zoom.x;
