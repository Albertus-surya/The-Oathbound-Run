extends Node2D

var death_effect_scene = preload("res://scenes/death_effect.tscn") 

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_dead: bool = false

func _ready():
	anim.play("default")
	if has_node("HurtBox"):
		$HurtBox.area_entered.connect(_on_HurtBox_area_entered)
	if has_node("Killzone_player"):
		$Killzone_player.body_entered.connect(_on_Killzone_player_body_entered)

func _on_HurtBox_area_entered(area):
	if area.is_in_group("player_attack") or area.name == "HitboxArea" or area.name == "CollisionAttack":
		die()

func _on_Killzone_player_body_entered(body):
	if body.has_method("die"):
		body.die()

func die():
	if is_dead: return
	is_dead = true
	
	if has_node("Killzone_player"): $Killzone_player.set_deferred("monitoring", false)
	if has_node("HurtBox"): $HurtBox.set_deferred("monitoring", false)
	
	spawn_effect()
	
	# Efek Hitstop & Shake 
	GameManager.do_hitstop(0.02)
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("apply_shake"):
		camera.apply_shake(1.8)
	
	anim.play("die")
	await anim.animation_finished
	queue_free()

func spawn_effect():
	if death_effect_scene:
		var effect_instance = death_effect_scene.instantiate()
		
		effect_instance.global_position = global_position
		
		effect_instance.rotation = randf_range(0, 360)
		
		get_parent().add_child(effect_instance)
