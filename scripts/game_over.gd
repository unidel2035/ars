extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var score_label := $VBoxContainer/ScoreLabel as Label
	if score_label:
		score_label.text = "Score: %d" % GameManager.score


func _on_retry_pressed() -> void:
	GameManager.start_game()


func _on_menu_pressed() -> void:
	GameManager.go_to_menu()
