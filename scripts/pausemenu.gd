extends CanvasLayer

@onready var btn_resume = $Button

func _ready():
	visible = false 

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		var current_path = get_tree().current_scene.scene_file_path
		
		# tidak akan terbuka di 
		var forbidden_files = [
			"mainmenu.tscn", 
			"finish_menu.tscn", 
			"game_over.tscn", 
			"charmenu.tscn", 
			"levelmenu.tscn"
		]
		
		for file in forbidden_files:
			if file in current_path:
				return 

		toggle_pause()

func toggle_pause():
	var is_paused = get_tree().paused
	get_tree().paused = not is_paused
	visible = not is_paused
	
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
		$Button.grab_focus() 
		
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# fungsi tombol
func _on_button_pressed() -> void:
	toggle_pause() 

func _on_button_2_pressed() -> void:
	get_tree().paused = false 
	visible = false
	get_tree().change_scene_to_file("res://mainmenu.tscn")
