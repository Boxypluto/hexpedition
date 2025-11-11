extends Node2D
class_name Level

@export var player: Player
@export var doors: Array[Door]

var souls = 0;

func _ready() -> void:
	souls = $TotalEnemy.get_child_count();
	assert(player != null, "Level " + name + " does not have a player assigned!")
	GlobalVariables.currentLevel = self;
	for door: Door in doors:
		door.level = self
