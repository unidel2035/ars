extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var score_label := $VBoxContainer/ScoreLabel as Label
	if score_label:
		score_label.text = "Final Score: %d" % GameManager.score


func _on_menu_pressed() -> void:
	GameManager.go_to_menu()


func _on_quit_pressed() -> void:
	get_tree().quit()
