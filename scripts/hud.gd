extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var ammo_label: Label = $AmmoLabel


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	var player = get_parent()
	if player:
		health_label.text = "HP: %d" % player.health
		ammo_label.text = "Ammo: %d / %d" % [player.current_ammo, player.max_ammo]
