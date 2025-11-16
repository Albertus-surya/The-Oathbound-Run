extends Area2D

func _on_area_entered(area):
	# Jika terkena serangan player
	if area.name == "CollisionAttack":   
		owner.die()
