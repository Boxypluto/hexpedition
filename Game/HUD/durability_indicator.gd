extends Sprite2D
class_name DurabilityIndicator

@onready var break_particles: GPUParticles2D = $BreakParticles

var durability: int = 0:
	set(new):
		var old: int = durability
		if new == durability: return
		durability = clampi(new, 0, 3)
		_update_durability(old)

const TEXTURE_WIDTH: int = 64

func _update_durability(old: int):
	var change: int = durability - old
	if change == 0:
		self_modulate.a = 0.0
		return
	self_modulate.a = 1.0
	texture.region.position.x = TEXTURE_WIDTH * (3 - durability)
	if durability == 0:
		if break_particles == null: return
		break_particles.emitting = true
		await get_tree().create_timer(0.4).timeout
		break_particles.emitting = false
