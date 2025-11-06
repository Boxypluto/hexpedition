extends Sprite2D
class_name BreakEffect

func do_break():
	return
	visible = true
	await get_tree().create_timer(0.05).timeout
	visible = false
