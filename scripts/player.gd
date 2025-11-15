# Skrip Karakter Runner (LENGKAP DENGAN GRAVITY FLIP)
# Versi ini 100% bersih dari karakter spasi ilegal.
extends CharacterBody2D

# === KONSTANTA & KECEPATAN ===
const RUN_SPEED: float = 300.0
const JUMP_FORCE: float = -400.0
const GRAVITY_DEFAULT: float = 1200.0
const FLIP_BOOST: float = -200.0

# === REFERENSI NODE (WAJIB SESUAI NAMA DI POHON SCENE) ===
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col_stand: CollisionShape2D = $CollisionStand
@onready var col_slide: CollisionShape2D = $CollisionSlide
@onready var hitbox_col: CollisionShape2D = $HitboxArea/CollisionAttack
@onready var double_tap_timer: Timer = $DoubleTapTimer

# === VARIABEL STATUS (STATE) ===
var is_sliding: bool = false
var is_attacking: bool = false
# 1 = Gravitasi Normal (Bawah), -1 = Gravitasi Terbalik (Atas)
var gravity_direction: int = 1
var can_double_tap: bool = false # Status untuk cek double click

# Fungsi _ready() dipanggil sekali saat scene dimulai
func _ready():
	# Memastikan status awal sudah benar
	col_stand.disabled = false
	col_slide.disabled = true
	hitbox_col.disabled = true
	
	# Menghubungkan sinyal (WAJIB)
	if not anim.animation_finished.is_connected(_on_animation_finished):
		anim.animation_finished.connect(_on_animation_finished)
		
	if not double_tap_timer.timeout.is_connected(_on_double_tap_timer_timeout):
		double_tap_timer.timeout.connect(_on_double_tap_timer_timeout)

# Fungsi _input() menangani input sekali tekan (Jump/Flip)
func _input(event):
	if event.is_action_pressed("jump"):
		if is_attacking or is_sliding:
			return
			
		if can_double_tap:
			# --- DOUBLE TAP (FLIP GRAVITASI) ---
			perform_gravity_flip()
			can_double_tap = false
			double_tap_timer.stop()
		else:
			# --- SINGLE TAP (LOMPAT BIASA) ---
			if is_on_floor():
				perform_jump()
				can_double_tap = true
				double_tap_timer.start()

# Fungsi _physics_process() untuk fisika (Gravitasi, Lari, Slide, Attack)
func _physics_process(delta):
	# 1. APLIKASI GRAVITASI
	if not is_on_floor():
		velocity.y += (GRAVITY_DEFAULT * gravity_direction) * delta
	
	# 2. LARI OTOMATIS
	velocity.x = RUN_SPEED
	
	# 3. PROSES INPUT (Attack & Slide)
	if is_attacking:
		pass
	elif is_sliding:
		if Input.is_action_just_released("slide"):
			stop_slide()
	else:
		# Jika sedang normal (lari)
		if Input.is_action_just_pressed("attack") and is_on_floor():
			perform_attack()
		elif Input.is_action_pressed("slide") and is_on_floor():
			start_slide()

	# 4. UPDATE ANIMASI
	update_animations()

	# 5. GERAKKAN KARAKTER
	move_and_slide()

# === FUNGSI AKSI (ACTIONS) ===

func perform_jump():
	velocity.y = JUMP_FORCE * gravity_direction

func perform_gravity_flip():
	gravity_direction *= -1
	up_direction = -up_direction
	velocity.y = FLIP_BOOST * gravity_direction

func perform_attack():
	if is_attacking: return
	is_attacking = true
	hitbox_col.set_deferred("disabled", false)

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

# === FUNGSI ANIMASI & SINYAL ===

func update_animations():
	anim.flip_v = (gravity_direction == -1)
	
	if velocity.x == 0:
		anim.play("default")
	elif is_attacking:
		anim.play("attack")
	elif is_sliding:
		anim.play("slide")
	elif not is_on_floor():
		anim.play("jump")
	else:
		anim.play("run")

func _on_animation_finished():
	if anim.animation == "attack":
		is_attacking = false
		hitbox_col.set_deferred("disabled", true)

func _on_double_tap_timer_timeout():
	can_double_tap = false

# === FUNGSI MATI (DIE) ===
func die():
	print("PLAYER MATI!")
	velocity = Vector2.ZERO
	set_physics_process(false)
	
	col_stand.set_deferred("disabled", true)
	col_slide.set_deferred("disabled", true)
	
	# (Opsional) Putar animasi mati jika Anda punya
	# anim.play("die") 
	
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
