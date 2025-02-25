extends CharacterBody3D


const WALK_SPEED = 3.0
const RUN_SPEED = 5.0

var runing = false
var speed = WALK_SPEED
const SENSIBILITY = 0.003

# Camera
@onready var camera_pivot: Node3D = $camera_pivot
@onready var camera: Camera3D = $camera_pivot/camera
@onready var raycast: RayCast3D = $camera_pivot/camera/raycast

@onready var flashlight: Area3D = $camera_pivot/camera/Flashlight
@onready var flashlight_light: SpotLight3D = $camera_pivot/camera/Flashlight/flashlight_light

@onready var stamina_bar: ProgressBar = $camera_pivot/HUD/CenterContainer/stamina_bar

var holding_obj
var init_obj_pos := Vector3()

const MIN_CAMX = deg_to_rad(-40)
const MAX_CAMX = deg_to_rad(60)

const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var bob_time = 0.0

var looking_obj

# Fov camera
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var max_stamina = 100.0
var stamina = max_stamina
var stamina_rate = 10
var min_run_stamina = 20
var stamina_cooldown = 3
var curr_stamina_cooldown = 0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.player = self
	Global.camera = camera
	Global.hud = $camera_pivot/HUD
	
	holding_obj = null
	init_obj_pos = Vector3.ZERO
	flashlight.visible = false
	
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina

func _unhandled_input(event: InputEvent) -> void:
	if !Global.pause && event is InputEventMouseMotion:
		camera_pivot.rotate_y(-event.relative.x * SENSIBILITY)
		camera.rotate_x(-event.relative.y * SENSIBILITY)
		camera.rotation.x = clamp(camera.rotation.x, MIN_CAMX, MAX_CAMX)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if stamina > min_run_stamina && Input.is_action_just_pressed("run"):
		runing = !runing
	
	if stamina <= 0:
		runing = false
	
	bob_time += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _head_bob(bob_time)
	
	if Input.is_action_just_pressed("pause"):
		Global.pause = !Global.pause
	
	if Global.pause:
		return

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if runing && direction:
		speed = RUN_SPEED
		stamina -= stamina_rate * delta
		curr_stamina_cooldown = 0
	else:
		speed = WALK_SPEED
		if curr_stamina_cooldown >= stamina_cooldown:
			stamina += stamina_rate * delta * 2
		else:
			curr_stamina_cooldown += delta
	
	stamina = clamp(stamina, 0, max_stamina)
	stamina_bar.value = stamina
	
	if stamina >= max_stamina:
		stamina_bar.modulate.a = lerp(stamina_bar.modulate.a, 0.0, 2.0 * delta)
	else:
		stamina_bar.modulate.a = lerp(stamina_bar.modulate.a, 10.0, 2.0 * delta)
	
	if Input.is_action_just_pressed("mb_left"):
		flashlight_light.visible = !flashlight_light.visible
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if holding_obj: holding_obj.transform.origin = init_obj_pos - (_head_bob(bob_time)*velocity.length()/2)/8
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 8)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 8)
		if holding_obj: holding_obj.transform.origin = lerp(holding_obj.transform.origin, init_obj_pos, delta * 5)

	var velocity_clamp = clamp(velocity.length(), 0.5, RUN_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamp
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	var curr_looking_obj = raycast.get_collider()

	if curr_looking_obj != looking_obj:
		if is_instance_valid(looking_obj) && looking_obj.has_signal("unfocused"):
			looking_obj.emit_signal("unfocused")
		
		looking_obj = null
		
		if curr_looking_obj && curr_looking_obj.has_signal("focused"):
			looking_obj = curr_looking_obj
			looking_obj.emit_signal("focused")
	
	if looking_obj && Input.is_action_just_pressed("interact"):
		looking_obj.emit_signal("interacted")
	
	
	move_and_slide()

func _head_bob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	return pos

func hold_obj(object_name: String) -> void:
	match object_name:
		"flashlight":
			flashlight.visible = true
			init_obj_pos = flashlight.transform.origin
			holding_obj = flashlight
	
