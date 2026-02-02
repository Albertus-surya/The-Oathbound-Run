extends Area2D

@onready var sfx = $AudioStreamPlayer2D
@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

func _ready():
	# (Kode animasi naik turun kamu biarkan saja di sini)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Cek jika Player yang menabrak
	if body.name == "Player" or body is CharacterBody2D:
		
		# 1. Tambah Uang (Logika GameManager kamu)
		GameManager.add_coin(1)
		
		# 2. Mainkan Suara
		sfx.play()
		
		# 3. "Hilangkan" Koin secara visual & fisik dulu
		sprite.visible = false  # Sembunyikan gambar biar terlihat sudah diambil
		collision.set_deferred("disabled", true) # Matikan tabrakan biar gak keambil 2x
		
		# 4. TUNGGU sampai suara selesai berbunyi
		await sfx.finished
		
		# 5. Baru hapus koin dari memory selamanya
		queue_free()
