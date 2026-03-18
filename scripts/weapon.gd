extends Node3D

# Анимация отдачи
var recoil_amount := 0.0
var original_position: Vector3


func _ready() -> void:
	original_position = position
	_setup_gun_meshes()


func _setup_gun_meshes() -> void:
	# Корпус автомата
	var body := $GunBody as MeshInstance3D
	var body_mesh := BoxMesh.new()
	body_mesh.size = Vector3(0.06, 0.06, 0.3)
	body.mesh = body_mesh

	# Ствол
	var barrel := $GunBarrel as MeshInstance3D
	var barrel_mesh := BoxMesh.new()
	barrel_mesh.size = Vector3(0.03, 0.03, 0.25)
	barrel.mesh = barrel_mesh

	# Рукоять
	var grip := $GunGrip as MeshInstance3D
	var grip_mesh := BoxMesh.new()
	grip_mesh.size = Vector3(0.04, 0.1, 0.04)
	grip.mesh = grip_mesh


func _process(delta: float) -> void:
	# Плавное возвращение после отдачи
	if recoil_amount > 0:
		recoil_amount = move_toward(recoil_amount, 0, delta * 10.0)
		position.z = original_position.z + recoil_amount * 0.05
		rotation.x = recoil_amount * 0.1
	else:
		position = original_position
		rotation.x = 0

	# Покачивание при ходьбе
	var player := get_parent().get_parent() as CharacterBody3D
	if player and player.velocity.length() > 0.5 and player.is_on_floor():
		var bob_speed := 10.0
		var bob_amount := 0.003
		position.y = original_position.y + sin(Time.get_ticks_msec() * 0.001 * bob_speed) * bob_amount


func play_shoot() -> void:
	recoil_amount = 1.0
