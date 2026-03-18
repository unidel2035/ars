extends Area3D

# Портал на следующий уровень — появляется когда все враги убиты

var activated := false


func _ready() -> void:
	visible = false
	monitoring = false
	body_entered.connect(_on_body_entered)


func _process(_delta: float) -> void:
	if activated:
		return

	# Проверяем остались ли враги
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		activate()


func activate() -> void:
	activated = true
	visible = true
	monitoring = true


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameManager.next_level()
