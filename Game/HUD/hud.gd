extends CanvasLayer

func _process(_delta: float) -> void:
	$Souls/Label.text = str(abs(get_parent().get_node("TotalEnemy").get_child_count()-get_parent().souls))+"/"+str(get_parent().souls);
	if get_parent().has_node("Player"):
		$Health/Current.size.x += ((229.0*(get_parent().get_node("Player").health/100.0))-$Health/Current.size.x)/15.0;
		$Stamina/Current.size.x += ((151.0*(get_parent().get_node("Player").stamina/12.0))-$Stamina/Current.size.x)/15.0;
	else:
		$Health/Current.size.x += (0-$Health/Current.size.x)/15.0;
		$Stamina/Current.size.x += (0-$Stamina/Current.size.x)/15.0;
	if Input.is_action_just_pressed("ui_cancel"):
		print(get_parent().get_node("Player").global_position);
		for i in get_parent().get_node("TotalEnemy").get_child_count():
			print(get_parent().get_node("TotalEnemy").get_child(i).global_position)
