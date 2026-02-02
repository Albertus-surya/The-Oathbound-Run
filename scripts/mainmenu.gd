extends Control

var speed = 100 

@onready var parallax_bg = $ParallaxBackground

func _process(delta):
	if parallax_bg:
		parallax_bg.scroll_offset.x -= speed * delta

func _on_play_pressed():
	# Panggil continue_game agar membaca level terakhir yang terbuka
	GameManager.continue_game()

func _on_quit_pressed():
	get_tree().quit()

func _on_levels_pressed():
	get_tree().change_scene_to_file("res://levelmenu.tscn")
	
func _on_charakter_pressed() -> void:
	get_tree().change_scene_to_file("res://charmenu.tscn")
