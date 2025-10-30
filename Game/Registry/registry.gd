class_name Registry

static var pickupables: Array[PickupableWeapon] = []

static func register_pickupable(pickupable: PickupableWeapon) -> void:
	pickupables.append(pickupable)

static func remove_pickupable(pickupable: PickupableWeapon) -> void:
	pickupables.erase(pickupable)
