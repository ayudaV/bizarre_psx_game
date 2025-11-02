extends Node3D

@onready var player: CharacterBody3D = $"../player"

func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	get_tree().call_group("enemy", "update_target_location", player.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(Global.hud):
		Global.hud.visible = !Global.pause
	pass
