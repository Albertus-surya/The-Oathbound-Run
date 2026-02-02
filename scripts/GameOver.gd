extends Control

var speed = 100 

@onready var parallax_bg = $ParallaxBackground

func _process(delta):
	parallax_bg.scroll_offset.x -= speed * delta

func _on_retry_button_pressed() -> void:
	GameManager.restart_level()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")
