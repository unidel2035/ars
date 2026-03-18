extends Node

# Автозагрузка (singleton) — управляет уровнями, счётом, состоянием игры

var current_level := 0
var score := 0
var is_paused := false

var levels := [
	"res://scenes/level_1.tscn",
	"res://scenes/level_2.tscn",
	"res://scenes/level_3.tscn",
]


func start_game() -> void:
	score = 0
	current_level = 0
	load_level(current_level)


func load_level(index: int) -> void:
	current_level = index
	is_paused = false
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file(levels[index])


func next_level() -> void:
	current_level += 1
	if current_level >= levels.size():
		# Все уровни пройдены — победа
		get_tree().change_scene_to_file("res://scenes/victory_screen.tscn")
	else:
		load_level(current_level)


func add_score(amount: int) -> void:
	score += amount


func game_over() -> void:
	is_paused = false
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func go_to_menu() -> void:
	is_paused = false
	Engine.time_scale = 1.0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	Engine.time_scale = 0.0 if is_paused else 1.0
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
