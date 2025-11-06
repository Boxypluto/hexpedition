extends Node

func load_level(level_scene: PackedScene, current_scene: Node = null, door_id: int = -1):
	if current_scene != null:
		current_scene.queue_free()
	var scene: Level = level_scene.instantiate()
	get_tree().root.add_child(scene)
	if door_id != -1:
		var found_door: Door = null
		for door: Door in scene.doors:
			if door.id == door_id:
				found_door = door
				break
		assert(found_door != null, "No door of id: " + str(door_id) + " found in level: " + scene.name)
		scene.player.global_position = found_door.player_pos.global_position
