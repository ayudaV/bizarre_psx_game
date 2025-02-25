extends Node3D

func _ready() -> void:
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(Global.hud):
		Global.hud.visible = !Global.pause
	pass
