extends Node

# --- DATA PEMAIN ---
var coins: int = 0 
var current_skin_index: int = 0 

# --- VARIABEL PENTING UNTUK ANIMASI ---
var is_game_finished: bool = false 
# --------------------------------------

# --- DATA LEVEL ---
var unlocked_level_index: int = 0 
var level_coins: int = 0
var levels = [
	"res://scenes/level_1.tscn",
	"res://scenes/level_2.tscn",
	"res://scenes/level_3.tscn",
	"res://scenes/level_4.tscn",
	"res://scenes/level_5.tscn"
]
var current_level_index = 0

# --- DATA SKIN ---
var skins_data = [
	{
		"name": "Valiant Origins",
		"price": 0,
		"resource": "res://scenes/skin_0_default.tres", 
		"image": "res://scenes/Valiant Origins.tres",           
		"owned": true 
	},
	{
		"name": "Verdant Valiant",
		"price": 400,
		"resource": "res://scenes/skin_1_premium.tres", 
		"image": "res://scenes/Verdant Valiant.tres",           
		"owned": false 
	}
]

# --- SYSTEM SAVE/LOAD (BARU) ---
const SAVE_PATH = "user://savegame.data" # File ini ada di AppData komputer

func _ready():
	# Saat game baru dinyalakan, langsung load data lama
	load_game()

# --- FUNGSI ---

func add_coin(amount: int):
	coins += amount
	level_coins += amount
	print("Coins: ", coins)
	save_game() # Simpan setiap dapat koin (Opsional, biar aman)

func purchase_skin(index: int) -> bool:
	var skin = skins_data[index]
	if skin["owned"]:
		current_skin_index = index
		save_game() # Simpan saat ganti skin
		return true
	elif coins >= skin["price"]:
		coins -= skin["price"]
		skin["owned"] = true
		current_skin_index = index
		save_game() # Simpan saat beli skin
		return true
	return false

# Fungsi untuk memulai game benar-benar dari awal (Level 1)
func start_game():
	current_level_index = 0
	_reset_level_stats()
	get_tree().change_scene_to_file(levels[0])

# Fungsi BARU: Melanjutkan dari level terakhir yang terbuka
func continue_game():
	# Jika semua level sudah tamat (index melebihi jumlah level), ulang dari awal
	if unlocked_level_index >= levels.size():
		start_game()
	else:
		# Lanjut ke level yang sudah terbuka
		current_level_index = unlocked_level_index
		_reset_level_stats()
		get_tree().change_scene_to_file(levels[current_level_index])

func complete_level():
	var next_level_index = current_level_index + 1
	# Jika level selanjutnya lebih tinggi dari yang pernah dibuka, simpan progress
	if next_level_index > unlocked_level_index:
		unlocked_level_index = next_level_index
		print("Level Baru Terbuka! Level Index:", unlocked_level_index)
		save_game() # PENTING: Simpan saat level terbuka

# --- LOGIKA PINDAH LEVEL / ANIMASI TAMAT ---
func load_next_level():
	current_level_index += 1
	
	if current_level_index < levels.size():
		_reset_level_stats()
		get_tree().change_scene_to_file(levels[current_level_index])
		
	else:
		if is_game_finished == false:
			print("TAMAT! Memutar animasi ending...")
			is_game_finished = true 
			current_level_index = 0 
			_reset_level_stats()
			# Simpan status tamat
			save_game()
			get_tree().change_scene_to_file("res://scenes/animasi.tscn") 
		else:
			print("Sudah pernah tamat. Ke Main Menu.")
			current_level_index = 0
			_reset_level_stats()
			get_tree().change_scene_to_file("res://mainmenu.tscn")

func restart_level():
	if current_level_index >= 0 and current_level_index < levels.size():
		_reset_level_stats()
		get_tree().change_scene_to_file(levels[current_level_index])
	else:
		start_game()

func _reset_level_stats():
	level_coins = 0

func do_hitstop(duration: float):
	get_tree().paused = true
	await get_tree().create_timer(duration, true, false, true).timeout
	get_tree().paused = false

# ==========================================
# SAVE & LOAD 
# ==========================================

func save_game():
	# 1. Kita kumpulkan data skin yang sudah dibeli (True/False-nya saja)
	var owned_skins_status = []
	for skin in skins_data:
		owned_skins_status.append(skin["owned"])
	
	# 2. Bungkus semua data penting dalam Dictionary
	var data_to_save = {
		"coins": coins,
		"unlocked_level": unlocked_level_index,
		"current_skin": current_skin_index,
		"owned_skins": owned_skins_status,
		"game_finished": is_game_finished
	}
	
	# 3. Buka file di komputer user dan tulis datanya
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		# Ubah data jadi teks JSON dan simpan
		var json_string = JSON.stringify(data_to_save)
		file.store_string(json_string)
		print("Game Saved!")
	else:
		print("Gagal menyimpan game.")

func load_game():
	# 1. Cek apakah ada file save sebelumnya?
	if not FileAccess.file_exists(SAVE_PATH):
		print("Belum ada save file. Mulai baru.")
		return # Kalau gak ada, pakai settingan default (coins 0, level 0)

	# 2. Buka filenya
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var saved_data = JSON.parse_string(json_string)
		
		# 3. Masukkan data dari file ke variabel game
		if saved_data:
			coins = saved_data.get("coins", 0)
			unlocked_level_index = saved_data.get("unlocked_level", 0)
			current_skin_index = saved_data.get("current_skin", 0)
			is_game_finished = saved_data.get("game_finished", false)
			
			# Load kepemilikan skin
			var loaded_skins_status = saved_data.get("owned_skins", [])
			for i in range(min(skins_data.size(), loaded_skins_status.size())):
				skins_data[i]["owned"] = loaded_skins_status[i]
			
			print("Game Loaded! Coin:", coins, " Level:", unlocked_level_index)
