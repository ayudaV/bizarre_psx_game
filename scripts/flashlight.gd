extends Area3D

func interact() -> void:
	Global.player.hold_obj("flashlight")
	visible = false
	emit_signal("unfocused")
	queue_free()
