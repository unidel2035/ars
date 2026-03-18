extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var ammo_label: Label = $AmmoLabel
@onready var score_label: Label = $ScoreLabel
@onready var level_label: Label = $LevelLabel


func _process(_delta: float) -> void:
	var player = get_parent()
	if player:
		health_label.text = "HP: %d" % player.health
		ammo_label.text = "Ammo: %d / %d" % [player.current_ammo, player.max_ammo]
	score_label.text = "Score: %d" % GameManager.score
	level_label.text = "Level %d" % (GameManager.current_level + 1)
