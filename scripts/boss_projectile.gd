extends Area2D

# --- SETTINGAN DI INSPECTOR ---
@export_group("Projectile Settings")
@export var normal_speed: float = 400.0
@export var reflected_speed: float = 800.0

# Variabel internal
var direction = -1 
var is_reflected = false
var current_speed = 0.0

@onready var anim = $AnimatedSprite2D 


func _ready():
	current_speed = normal_speed
	get_tree().create_timer(5.0).timeout.connect(queue_free)
	if anim: anim.play("default")

func _physics_process(delta):
	position.x += current_speed * direction * delta

func _on_body_entered(body):
	# 1. PENGAMAN BOSS
	if body.name == "boss" and not is_reflected:
		return 

	# 2. KENA PLAYER
	if body.name == "Player" or body.name == "player":
		if is_reflected: return

		# LOGIKA PARRY (Reflect jika player sedang nyerang)
		if body.get("is_attacking") == true:
			print(" -> Player menyerang badan peluru! REFLECT!")
			reflect_bullet()
			return 
		
		# Kalau tidak nyerang, mati
		if body.has_method("die"): body.die()
		queue_free()
		
	# 3. KENA BOSS
	elif body.name == "boss" and is_reflected:
		if body.has_method("take_damage"): body.take_damage()
		queue_free()
		
	# 4. TEMBOK
	else:
		if "Hitbox" in body.name: return
		queue_free()

func reflect_bullet():
	if is_reflected: return 
	
	is_reflected = true
	direction = 1 
	current_speed = reflected_speed 
	
	modulate = Color.RED
	rotation_degrees = 180
	
	set_collision_mask_value(2, false) 
	set_collision_mask_value(3, true)
