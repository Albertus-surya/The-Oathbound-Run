extends Control

@onready var coin_label = $TotalCoinLabel 

@onready var cards = [
	$CharList/CardDefault, 
	$CharList/CardPremium   
]

func _ready():
	update_ui()

func update_ui():
	if coin_label:
		coin_label.text = "Coins: " + str(GameManager.coins)
	
	for i in range(cards.size()):
		if i >= GameManager.skins_data.size(): break
			
		var card = cards[i]
		var data = GameManager.skins_data[i]
		
		# --- 1. AMBIL WADAH VBOX (Structure Baru) ---
		# Script akan mencari node bernama "VBoxContainer"
		var container = card.get_node_or_null("VBoxContainer")
		
		if container == null:
			print("ERROR: VBoxContainer tidak ditemukan di ", card.name)
			print("Tolong buat VBoxContainer dan masukkan isinya ke sana!")
			continue # Skip ke kartu berikutnya biar game gak crash
		
		# --- 2. AMBIL ISI DARI DALAM CONTAINER ---
		var char_img = container.get_node_or_null("IconHolder/Portrait")
		var lock_icon = container.get_node_or_null("IconHolder/LockIcon")
		var lbl_info = container.get_node_or_null("InfoLabel")
		var btn_action = container.get_node_or_null("BtnAction")
		
		# Cek Safety (Jaga-jaga node hilang)
		if not char_img or not lbl_info or not btn_action:
			print("ERROR: Ada node yang hilang di dalam VBoxContainer pada ", card.name)
			continue

		# --- 3. LOAD GAMBAR ---
		if ResourceLoader.exists(data["image"]):
			char_img.texture = load(data["image"])
		
		# --- 4. LOGIKA TAMPILAN (VISUAL) ---
		if data["owned"]:
			# --- KONDISI SUDAH PUNYA ---
			if lock_icon: lock_icon.visible = false
			
			# Gambar Karakter Terang (Normal)
			char_img.modulate = Color(1, 1, 1, 1) 
			
			# Teks Rapi
			lbl_info.text = data["name"]
			
			if GameManager.current_skin_index == i:
				btn_action.text = "SELECTED"
				btn_action.disabled = true
			else:
				btn_action.text = "EQUIP"
				btn_action.disabled = false
		else:
			# --- KONDISI BELUM PUNYA (LOCKED) ---
			if lock_icon: lock_icon.visible = true
			
			# Gelapkan Karakter biar Gembok Kelihatan Jelas
			char_img.modulate = Color(0.3, 0.3, 0.3, 1) 
			
			# Format Teks Rapi (Nama di atas, Harga di bawah)
			lbl_info.text = "%s\nPrice: %d" % [data["name"], data["price"]]
			
			btn_action.text = "BUY"
			btn_action.disabled = (GameManager.coins < data["price"])

func _on_card_default_btn_action_pressed():
	handle_click(0)

func _on_card_premium_btn_action_pressed():
	handle_click(1)

func handle_click(index):
	if GameManager.purchase_skin(index):
		update_ui()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")
