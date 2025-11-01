class_name Pickable extends Node3D

@export var item_name: String
var follow: Node3D
var can_interact: bool = true

func _process(_delta: float) -> void:
	if (follow != null):
		if (global_position.distance_to(follow.global_position) > 5):
			global_position = lerp(global_position, follow.global_position, 0.2)
		else:
			global_position = follow.global_position
		

func interact():
	if (can_interact && Global.player.can_hold):
		Global.player.hold_obj(item_name, self)
		emit_signal("unfocused")
