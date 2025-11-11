extends Control
var animation_timer = 1;
var change = false;

@onready var title: Sprite2D = $CenterContainer/Control/Title
@onready var demo: Sprite2D = $CenterContainer/Control/Title/Demo
@onready var cont: Sprite2D = $CenterContainer/Control/Title/Continue
@onready var tile_map: TileMapLayer = $TileMapLayer

func _ready():
	title.scale.x = 0;
	GlobalVariables.currentLevel = self;

func _process(delta):
	title.scale.x = lerpf(title.scale.x, 1.0, 0.01)
	title.scale.y = title.scale.x;
	tile_map.scale.x = lerpf(tile_map.scale.x, 1.0, 0.05)
	tile_map.scale.y = tile_map.scale.x;
	animation_timer -= delta;
	if animation_timer < 0:
		animation_timer = 2;
	if animation_timer > 1:
		demo.scale.x += (0.63-demo.scale.x)/1.5*delta;
	else:
		demo.scale.x += (0.4-demo.scale.x)/1.5*delta;
	demo.scale.y = demo.scale.x;
	cont.scale = demo.scale/1.5;
	if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("ui_accept"):
		change = true;
	if change:
		title.modulate.a -= delta*2;
		if title.modulate.a < 0.01:
			get_tree().change_scene_to_file("res://Levels/DemoLevel.tscn");
