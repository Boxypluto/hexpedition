extends CanvasLayer

@onready var duability_indicator: DurabilityIndicator = $Control/DuabilityIndicator

func _process(_delta: float) -> void:
	$Souls/Label.text = str(abs(get_parent().get_node("TotalEnemy").get_child_count()-get_parent().souls))+"/"+str(get_parent().souls);
	if get_parent().has_node("Player"):
		$Health/Current.size.x += ((229.0*(get_parent().get_node("Player").health/100.0))-$Health/Current.size.x)/15.0;
		$Stamina/Current.size.x += ((151.0*(get_parent().get_node("Player").stamina/12.0))-$Stamina/Current.size.x)/15.0;
	else:
		$Health/Current.size.x += (0-$Health/Current.size.x)/15.0;
		$Stamina/Current.size.x += (0-$Stamina/Current.size.x)/15.0;
	if !get_parent().has_node("Player") or get_parent().get_node("TotalEnemy").get_child_count() == 0:
		$GameOver.scale.x += (1.0-$GameOver.scale.x)/15.0;
		$GameOver.scale.y = $GameOver.scale.x;
		$GameOver.modulate.a += (1.0-$GameOver.modulate.a)/15.0;
		if $GameOver.modulate.a > 0.75:
			if Input.is_action_just_pressed("ui_accept"):
				if get_parent().get_node("TotalEnemy").get_child_count() == 0:
					get_tree().quit();
				else:
					get_tree().reload_current_scene()
		if !$GameOver.visible:
			$GameOver.show();
			$GameOver.texture = load("res://Game/HUD/You Win.svg");
			if !get_parent().has_node("Player"):
				$GameOver.texture = load("res://Game/HUD/Game Over.svg");
	else:
		$GameOver.hide();
		$GameOver.modulate.a = 0;
	
