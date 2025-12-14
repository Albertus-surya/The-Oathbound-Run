extends Control

var speed = 100 

@onready var parallax_bg = $ParallaxBackground

func _process(delta):
	# Ini bikin background jalan terus ke kiri
	parallax_bg.scroll_offset.x -= speed * delta

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")
