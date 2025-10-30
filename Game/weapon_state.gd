@abstract
extends Node2D
class_name WeaponState

@abstract func id() -> StringName

func enter():
	pass

func exit():
	pass

func do_action():
	pass

func physics_update(_delta: float):
	pass
