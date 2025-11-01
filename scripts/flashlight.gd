extends Area3D

@onready var flashlight_light: SpotLight3D = $flashlight_light

func interact() -> void:
	if (!Global.player.can_hold):
		return
		
	Global.player.hold_obj("flashlight")
	visible = false
	emit_signal("unfocused")
	queue_free()

func _process(delta: float) -> void:
	if !Global.pause && Input.is_action_just_pressed("mb_left") && Global.player.holding_obj == self:
		flashlight_light.visible = !flashlight_light.visible
