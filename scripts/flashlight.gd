extends Pickable

@onready var flashlight_light: SpotLight3D = $flashlight_light

func interact() -> void:
	if (!Global.player.can_hold):
		return
		
	Global.player.hold_obj("flashlight", self)
	emit_signal("unfocused")

func _process(delta: float) -> void:
	if !Global.pause && Input.is_action_just_pressed("mb_left") && Global.player.holding_obj == self:
		flashlight_light.visible = !flashlight_light.visible
