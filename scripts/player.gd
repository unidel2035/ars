extends CharacterBody3D

# Настройки движения
@export var speed := 5.0
@export var jump_force := 4.5
@export var gravity := 9.8
@export var mouse_sensitivity := 0.002

# Настройки стрельбы
@export var max_ammo := 30
@export var damage := 25.0
@export var fire_rate := 0.1

var current_ammo: int
var can_shoot := true
var health := 100.0

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var shoot_timer: Timer = $ShootTimer
@onready var muzzle_flash: OmniLight3D = $Camera3D/MuzzleFlash
@onready var weapon: Node3D = $Camera3D/Weapon
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_ammo = max_ammo
	shoot_timer.wait_time = fire_rate
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	muzzle_flash.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if GameManager.is_paused:
		return

	# Поворот камеры мышкой
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)


func _physics_process(delta: float) -> void:
	if GameManager.is_paused:
		return

	# Гравитация
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Прыжок
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force

	# Направление движения
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

	# Стрельба
	if Input.is_action_pressed("shoot") and can_shoot and current_ammo > 0:
		shoot()

	# Перезарядка
	if Input.is_action_just_pressed("reload"):
		reload()


func shoot() -> void:
	can_shoot = false
	current_ammo -= 1
	shoot_timer.start()

	# Анимация оружия
	if weapon and weapon.has_method("play_shoot"):
		weapon.play_shoot()

	# Вспышка выстрела
	muzzle_flash.visible = true
	get_tree().create_timer(0.05).timeout.connect(func(): muzzle_flash.visible = false)

	# Проверяем попадание
	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target.has_method("take_damage"):
			target.take_damage(damage)


func reload() -> void:
	current_ammo = max_ammo


func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		health = 0
		die()


func die() -> void:
	GameManager.game_over()


func _on_shoot_timer_timeout() -> void:
	can_shoot = true
