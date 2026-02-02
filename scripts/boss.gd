extends CharacterBody2D

const RUN_SPEED = 300.0
var hp = 3
var is_active = false
var is_dead = false

var projectile_scene = preload("res://scenes/boss_projectile.tscn")

@onready var anim = $AnimatedSprite2D
@onready var muzzle = $Muzzle
@onready var shoot_timer = $ShootTimer
@onready var detection_zone = $DetectionZone 
@onready var health_bar = $HealthBar
@onready var sfx_shoot = $SfxShoot 

func _ready():
	# Cek anim run
	if anim.sprite_frames.has_animation("run"):
		anim.play("run")
	
	# Set Health Bar penuh 
	if health_bar:
		health_bar.play("3")
	
	if detection_zone:
		detection_zone.body_entered.connect(_on_radar_triggered)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta):
	if not is_active or is_dead: return
	
	if not is_on_floor(): velocity.y += 980 * delta
	velocity.x = RUN_SPEED
	move_and_slide()

func _on_radar_triggered(body):
	if "player" in body.name.to_lower() and not is_active:
		is_active = true
		shoot_timer.start(2.0)
		print("BOSS: Player ketemu! Lari!")
		detection_zone.queue_free()

func _on_shoot_timer_timeout():
	if not is_dead: shoot()

func shoot():
	print("Boss Nembak!") 
	
	# --- MAINKAN SUARA TEMBAK ---
	if sfx_shoot:        
		sfx_shoot.play() 
	# ----------------------------

	var bullet = projectile_scene.instantiate()
	bullet.global_position = muzzle.global_position
	get_parent().add_child(bullet)

func take_damage():
	if is_dead: return
	
	hp -= 1
	print("BOSS: Kena Hit! HP:", hp)
	
	if health_bar:
		health_bar.play(str(hp))
	
	if hp <= 0:
		die()
	else:
		GameManager.do_hitstop(0.1)

func die():
	is_dead = true
	shoot_timer.stop()
	velocity = Vector2.ZERO
	
	$CollisionShape2D.set_deferred("disabled", true)
	print("BOSS KALAH! Boss akan menghilang.")
	
	if health_bar:
		health_bar.play("0")
	
	await get_tree().create_timer(1.0).timeout
	queue_free()
