extends Control


func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameManager.toggle_pause()
		visible = GameManager.is_paused
		get_viewport().set_input_as_handled()


func _on_resume_pressed() -> void:
	GameManager.toggle_pause()
	visible = false


func _on_menu_pressed() -> void:
	GameManager.go_to_menu()


func _on_quit_pressed() -> void:
	get_tree().quit()
