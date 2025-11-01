extends Area3D

@export var item_name: String
var follow: Node3D
var can_interact: bool = true

func _process(_delta: float) -> void:
	if (follow != null):
		global_position = follow.global_position
		rotation = follow.rotation

func interact():
	if (can_interact && Global.player.can_hold):
		Global.player.hold_obj(item_name, self)
		emit_signal("unfocused")
