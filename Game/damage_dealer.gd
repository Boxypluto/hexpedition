extends Area2D
class_name DamageDealer

var has_hit: bool = false

func _ready():
	body_entered.connect(do_hit)

func do_hit(other: Node2D):
	if other.has_method(&"damage"):
		print("HIT")
		other.damage((other.global_position - global_position).normalized()*50, 25)
		has_hit = true

func _physics_process(_delta: float) -> void:
	if has_hit:
		hit.emit()
		has_hit = false

signal hit
