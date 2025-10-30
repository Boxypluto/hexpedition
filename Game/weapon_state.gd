@abstract
extends Node2D
class_name WeaponState

@abstract func id() -> StringName

@onready var machine: WeaponStateMachine = get_parent()

func enter():
	pass

func exit():
	pass

func do_action():
	pass

func physics_update(_delta: float):
	pass
