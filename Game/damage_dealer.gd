extends Area2D
class_name DamageDealer

@export var knockback: float = 50
@export var damage: float = 30

var has_hit: bool = false
var last_damaged: Node = null

func _ready():
	if get_parent().name == "Weaponless":
		damage = 5;
	body_entered.connect(do_hit)

func do_hit(other: Node2D):
	if other.has_method(&"damage"):
		other.damage((other.global_position - global_position).normalized() * knockback, damage)
		last_damaged = other
		has_hit = true

func _physics_process(_delta: float) -> void:
	if has_hit:
		hit.emit()
		has_hit = false

func damage_last(damage_amount: float) -> void:
	if last_damaged != null:
		last_damaged.damage((last_damaged.global_position - global_position).normalized() * knockback, damage_amount)

signal hit
