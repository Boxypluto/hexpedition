@abstract
extends RigidBody2D
class_name PickupableWeapon

@export var pickup_area: Area2D
@export var id: StringName = &'None'

func _ready() -> void:
	assert(pickup_area != null, "Pickupable Weapon " + id + " has no assigned pickup_area!")
