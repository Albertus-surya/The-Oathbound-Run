extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_dead: bool = false

func _ready():
	anim.play("default")
	$HurtBox.area_entered.connect(_on_HurtBox_area_entered)
	$Killzone_player.body_entered.connect(_on_Killzone_player_body_entered)

func _on_HurtBox_area_entered(area):
	print("HurtBox triggered by:", area)
	if area.is_in_group("player_attack") or area.name == "HitboxArea" or area.name == "CollisionAttack":
		print("Enemy kena serangan -> die() dipanggil")
		die()

func _on_Killzone_player_body_entered(body):
	print("Killzone hit by:", body)
	if body.has_method("die"):
		print("Memanggil body.die()")
		body.die()

func die():
	if is_dead: return
	is_dead = true
	$Killzone_player.set_deferred("monitoring", false)
	$HurtBox.set_deferred("monitoring", false)
	anim.play("die")
	await anim.animation_finished
	queue_free()
