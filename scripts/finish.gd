extends Area2D

var level_completed = false

func _on_body_entered(body):
	if body.name == "player" and not level_completed:
		level_completed = true  
		
		print("Finish tersentuh di level index: ", GameManager.current_level_index)
		
		# 1. Simpan progress (koin & unlock level)
		GameManager.complete_level() 
		
		# 2. Tentukan tujuan selanjutnya
		call_deferred("cek_tujuan_selanjutnya")

func cek_tujuan_selanjutnya():
	# Ambil total jumlah level (misal 5)
	var total_levels = GameManager.levels.size()
	
	# Ambil index level saat ini (misal Level 5 itu indexnya 4)
	var current_idx = GameManager.current_level_index
	
	# LOGIKA:
	# Jika index saat ini adalah index terakhir (4), berarti ini Level 5.
	if current_idx >= total_levels - 1:
		# --- KASUS LEVEL TERAKHIR ---
		# Langsung panggil load_next_level milik GameManager.
		# GameManager akan mendeteksi index habis -> Buka Animasi.
		print("Level Terakhir! Langsung ke Animasi...")
		GameManager.load_next_level()
		
	else:
		# --- KASUS LEVEL BIASA (1-4) ---
		# Buka Finish Menu seperti biasa
		print("Level Biasa. Buka Menu Finish.")
		get_tree().change_scene_to_file("res://finish_menu.tscn")
