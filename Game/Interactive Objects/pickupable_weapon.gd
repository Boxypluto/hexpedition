extends RigidBody2D
class_name PickupableWeapon

@export var id: StringName = &'None'
@export var outlined_node: Node2D

var highlighted: bool = false
var positionChange = true;

func _physics_process(_delta: float) -> void:
	if outlined_node != null:
		assert(outlined_node.material is ShaderMaterial, "Outlined Node for a Pickupable (" + id + ") must have an \"outline\" shader!")
		outlined_node.material.set_shader_parameter("active", highlighted)
	$PickUp.global_rotation = 0;
	$PickUp.global_position.x = global_position.x;
	$PickUp.scale.x -= 0.02;
	if $PickUp.scale.x < -1:
		$PickUp.scale.x = 1;
		positionChange = !positionChange;
	if positionChange:
		$PickUp.global_position.y = lerp($PickUp.global_position.y,global_position.y-36.0,0.02);
	else:
		$PickUp.global_position.y = lerp($PickUp.global_position.y,global_position.y-14.0,0.02);

func _ready() -> void:
	Registry.register_pickupable(self)

func do_pickup() -> StringName:
	Registry.remove_pickupable(self)
	print("DID PICKUP")
	queue_free()
	return id
