extends Control

@onready var anim = $AnimationPlayer

func _ready():
	anim.play("batu") 
	
	# Hubungkan signal jika animasi selesai
	if not anim.animation_finished.is_connected(_on_animation_finished):
		anim.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	# Tunggu 3 detik biar pemain sempat baca tulisan terakhir
	await get_tree().create_timer(3.0).timeout
	
	# Balik ke Main Menu
	get_tree().change_scene_to_file("res://mainmenu.tscn")
