extends Node3D
# Door opens in one fixed direction when any player is nearby,
# and closes when no player is within detection_radius.

@export var detection_radius: float = 4.0
@export var rotation_speed: float = 6.0
@export var max_turn_deg: float = 80.0
@export var open_direction: int = 1  # +1 for clockwise, -1 for counterclockwise
@export var is_locked : bool = false

var _original_yaw: float = 0.0
var _is_opening: bool = false

func _ready() -> void:
	_original_yaw = rotation.y

func _physics_process(delta: float) -> void:
	var player_nearby := _is_player_near()
	_is_opening = player_nearby

	if _is_opening:
		_open_door(delta)
	else:
		_close_door(delta)


func _is_player_near() -> bool:
	var players = get_tree().get_nodes_in_group("player")
	for p in players:
		if not p or not p is Node3D:
			continue
		var d = global_position.distance_to(p.global_position)
		if d <= detection_radius:
			return true
	return false


func _open_door(delta: float) -> void:
	if is_locked:
		return
		
	var max_turn_rad = deg_to_rad(max_turn_deg)
	var target_yaw = _original_yaw + open_direction * max_turn_rad
	rotation.y = lerp_angle(rotation.y, target_yaw, rotation_speed * delta)


func _close_door(delta: float) -> void:
	rotation.y = lerp_angle(rotation.y, _original_yaw, rotation_speed * delta)
