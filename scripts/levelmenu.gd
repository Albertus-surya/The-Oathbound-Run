extends Control

var speed = 100 

@onready var parallax_bg = $ParallaxBackground

func _process(delta):
	parallax_bg.scroll_offset.x -= speed * delta

@onready var level_buttons = [
	$GridContainer/Level1_Btn,
	$GridContainer/Level2_Btn,
	$GridContainer/Level3_Btn,
	$GridContainer/Level4_Btn,
	$GridContainer/Level5_Btn
]

func _ready():
	setup_buttons()

func setup_buttons():
	# Loop mengecek semua tombol level (0 sampai 4)
	for i in range(level_buttons.size()):
		var btn = level_buttons[i]
		
		if i <= GameManager.unlocked_level_index:
			# --- JIKA LEVEL TERBUKA ---
			btn.disabled = false 
			
			btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			
			if btn.has_node("Padlock"):
				btn.get_node("Padlock").visible = false
				
		else:
			btn.disabled = true
			
			btn.mouse_default_cursor_shape = Control.CURSOR_ARROW
			
			# Munculkan gambar gembok
			if btn.has_node("Padlock"):
				btn.get_node("Padlock").visible = true


func _on_level_1_btn_pressed() -> void:
	change_level(0)

func _on_level_2_btn_pressed() -> void:
	change_level(1)

func _on_level_3_btn_pressed() -> void:
	change_level(2)

func _on_level_4_btn_pressed() -> void:
	change_level(3)

func _on_level_5_btn_pressed() -> void:
	change_level(4)

# Fungsi helper untuk pindah scene lewat GameManager
func change_level(index_level):
	GameManager.current_level_index = index_level
	GameManager._reset_level_stats()
	get_tree().change_scene_to_file(GameManager.levels[index_level])


func _on_back_pressed():
	get_tree().change_scene_to_file("res://mainmenu.tscn")
