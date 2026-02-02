extends CharacterBody2D

const RUN_SPEED: float = 300.0
const JUMP_FORCE: float = -350.0
const GRAVITY_DEFAULT: float = 1200.0
const FLIP_BOOST: float = -200.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col_stand: CollisionShape2D = $CollisionStand
@onready var col_slide: CollisionShape2D = $CollisionSlide
@onready var hitbox_col: CollisionShape2D = $HitboxArea/CollisionAttack
@onready var double_tap_timer: Timer = $DoubleTapTimer
@onready var sfx_jump: AudioStreamPlayer = $AudioJump
@onready var sfx_attack: AudioStreamPlayer = $AudioAttack

var is_sliding: bool = false
var is_attacking: bool = false
var gravity_direction: int = 1
var can_double_tap: bool = false 

func _ready():
	col_stand.disabled = false
	col_slide.disabled = true
	hitbox_col.disabled = true
	
	# Load baju sesuai pilihan di Menu
	update_skin_visuals()
	
	if not anim.animation_finished.is_connected(_on_animation_finished):
		anim.animation_finished.connect(_on_animation_finished)
		
	if not double_tap_timer.timeout.is_connected(_on_double_tap_timer_timeout):
		double_tap_timer.timeout.connect(_on_double_tap_timer_timeout)

func update_skin_visuals():
	var index = GameManager.current_skin_index
	# Pastikan file resource benar-benar ada
	var resource_path = GameManager.skins_data[index]["resource"]
	
	anim.sprite_frames = load(resource_path)
	anim.play("default") # Typo 'eout' sudah dihapus

func _input(event):
	if event.is_action_pressed("jump"):
		if is_attacking or is_sliding: return
			
		if can_double_tap:
			perform_gravity_flip()
			can_double_tap = false
			double_tap_timer.stop()
		else:
			if is_on_floor():
				perform_jump()
				can_double_tap = true
				double_tap_timer.start()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += (GRAVITY_DEFAULT * gravity_direction) * delta
	
	velocity.x = RUN_SPEED
	
	if is_attacking:
		pass
	elif is_sliding:
		if Input.is_action_just_released("slide"):
			stop_slide()
	else:
		if Input.is_action_just_pressed("attack") and is_on_floor():
			perform_attack()
		elif Input.is_action_pressed("slide") and is_on_floor():
			start_slide()

	update_animations()
	move_and_slide()

# --- ACTIONS ---
func perform_jump():
	velocity.y = JUMP_FORCE * gravity_direction
	if sfx_jump: sfx_jump.play()

func perform_gravity_flip():
	gravity_direction *= -1
	up_direction = -up_direction
	velocity.y = FLIP_BOOST * gravity_direction

func perform_attack():
	if is_attacking: return
	is_attacking = true
	hitbox_col.set_deferred("disabled", false)
	if sfx_attack: sfx_attack.play()

func start_slide():
	if is_sliding: return
	is_sliding = true
	col_stand.set_deferred("disabled", true)
	col_slide.set_deferred("disabled", false)

func stop_slide():
	if not is_sliding: return
	is_sliding = false
	col_stand.set_deferred("disabled", false)
	col_slide.set_deferred("disabled", true)

func update_animations():
	anim.flip_v = (gravity_direction == -1)
	if is_attacking: anim.play("attack")
	elif is_sliding: anim.play("slide")
	elif not is_on_floor(): anim.play("jump")
	else: anim.play("run")

func _on_animation_finished():
	if anim.animation == "attack":
		is_attacking = false
		hitbox_col.set_deferred("disabled", true)

func _on_double_tap_timer_timeout():
	can_double_tap = false

func die():
	set_physics_process(false)
	velocity = Vector2.ZERO
	col_stand.set_deferred("disabled", true)
	if col_slide:
		col_slide.set_deferred("disabled", true)
		
	await get_tree().create_timer(0.5).timeout 
	
	# 4. Baru pindah scene setelah aman
	get_tree().change_scene_to_file("res://game_over.tscn")

func _on_body_entered(body):
	# Ini untuk deteksi musuh/rintangan, bukan finish line
	if body.name == "Player": 
		die()
