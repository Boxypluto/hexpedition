extends Node2D
var animation_timer = 1;
func _ready():
	$Title.scale.x = 0;
func _process(delta):
	$Title.position = get_viewport().size/2.0;
	$Title.scale.x += ((get_viewport().size.x/1200.0)-$Title.scale.x)/1.05*delta;
	$Title.scale.y = $Title.scale.x;
	animation_timer -= delta;
	if animation_timer < 0:
		animation_timer = 2;
	if animation_timer > 1:
		$Title/Demo.scale.x += (0.63-$Title/Demo.scale.x)/1.5*delta;
	else:
		$Title/Demo.scale.x += (0.4-$Title/Demo.scale.x)/1.5*delta;
	$Title/Demo.scale.y = $Title/Demo.scale.x;
	$Title/Continue.scale = $Title/Demo.scale/1.5;
