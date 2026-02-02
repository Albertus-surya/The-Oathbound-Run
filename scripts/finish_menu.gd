extends Control

var speed = 100 
@onready var parallax_bg = $ParallaxBackground
@onready var next_level_button = $Button2 

func _ready():
	if GameManager.current_level_index >= GameManager.levels.size():
		next_level_button.visible = false 
	else:
		next_level_button.visible = true

func _process(delta):
	if parallax_bg:
		parallax_bg.scroll_offset.x -= speed * delta

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")

func _on_button2_pressed():
	GameManager.load_next_level()
