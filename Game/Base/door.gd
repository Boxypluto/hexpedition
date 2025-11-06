extends StaticBody2D
class_name Door

@export_file_path("*.tscn") var goes_to: String
@export var id: int
@export var to_id: int
@onready var player_pos: Marker2D = $PlayerPos
var level: Level

func on_body_entered(body: Node2D) -> void:
	assert(goes_to != null, "D  oor does not have an assigned scene!")
	if body is Player:
		LevelLoader.load_level(load(goes_to), level, to_id)
