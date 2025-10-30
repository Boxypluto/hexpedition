extends RigidBody2D
class_name PickupableWeapon

@export var id: StringName = &'None'

var highlighted: bool = false

func _physics_process(delta: float) -> void:
	modulate.v = 1.5 if highlighted else 0.4

func _ready() -> void:
	Registry.register_pickupable(self)

func do_pickup() -> StringName:
	Registry.remove_pickupable(self)
	queue_free()
	return id
