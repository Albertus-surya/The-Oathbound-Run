extends Area2D

func _on_body_entered(body):
	if body.has_method("die"):
		body.die()


func _on_hurt_box_area_entered(_area: Area2D) -> void:
	pass 
