extends Camera2D

var shake_strength: float = 0.0
var shake_fade: float = 10 

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		
		# Acak posisi kamera (Efek Getar)
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		# Jika tidak ada getaran, pastikan offset 0 (kamera stabil)
		offset = Vector2.ZERO

func apply_shake(strength: float):
	shake_strength = strength
