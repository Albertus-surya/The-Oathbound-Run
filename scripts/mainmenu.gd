extends Control

# Kecepatan gerak background
var speed = 100 

@onready var parallax_bg = $ParallaxBackground

func _process(delta):
	# Ini bikin background jalan terus ke kiri
	parallax_bg.scroll_offset.x -= speed * delta

func _on_play_pressed():
	# Ganti ke scene level 1
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_quit_pressed():
	# Keluar game
	get_tree().quit()
