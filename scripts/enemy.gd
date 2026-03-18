extends CharacterBody3D

@export var health := 100.0
@export var speed := 3.0
@export var damage := 10.0
@export var attack_range := 2.0
@export var detection_range := 15.0
@export var score_value := 100

var player: CharacterBody3D = null
var is_dead := false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	add_to_group("enemies")
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if is_dead or player == null:
		return

	var distance_to_player := global_position.distance_to(player.global_position)

	if distance_to_player <= detection_range:
		nav_agent.target_position = player.global_position

		if not nav_agent.is_navigation_finished():
			var next_pos := nav_agent.get_next_path_position()
			var direction := (next_pos - global_position).normalized()
			direction.y = 0
			velocity = direction * speed
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

		if distance_to_player <= attack_range:
			velocity = Vector3.ZERO
			attack()
	else:
		velocity = Vector3.ZERO

	if not is_on_floor():
		velocity.y -= 9.8 * delta

	move_and_slide()


func attack() -> void:
	if player.has_method("take_damage"):
		player.take_damage(damage * get_physics_process_delta_time())


func take_damage(amount: float) -> void:
	if is_dead:
		return

	health -= amount

	var mesh := find_child("MeshInstance3D") as MeshInstance3D
	if mesh and mesh.material_override:
		var mat: StandardMaterial3D = mesh.material_override
		mat.albedo_color = Color.RED
		get_tree().create_timer(0.1).timeout.connect(func():
			if is_instance_valid(mat):
				mat.albedo_color = Color(0.8, 0.2, 0.2)
		)

	if health <= 0:
		die()


func die() -> void:
	is_dead = true
	GameManager.add_score(score_value)
	remove_from_group("enemies")
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector3(1.0, 0.1, 1.0), 0.3)
	tween.tween_callback(queue_free)
