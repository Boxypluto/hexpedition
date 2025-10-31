extends RigidBody2D
class_name PickupableWeapon

@export var id: StringName = &'None'
@export var outlined_node: Node2D

var highlighted: bool = false

func _physics_process(_delta: float) -> void:
	if outlined_node != null:
		assert(outlined_node.material is ShaderMaterial, "Outlined Node for a Pickupable (" + id + ") must have an \"outline\" shader!")
		outlined_node.material.set_shader_parameter("active", highlighted)

func _ready() -> void:
	Registry.register_pickupable(self)

func do_pickup() -> StringName:
	Registry.remove_pickupable(self)
	print("DID PICKUP")
	queue_free()
	return id
