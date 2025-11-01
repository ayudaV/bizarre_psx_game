extends Pickable

const SWEEP_SPD := 1.0

var sweeping: bool = false
var sweep: float

func _physics_process(delta: float) -> void:
	sweeping = Input.is_action_pressed("mb_left")

	if (is_held && sweeping):
		sweep += delta * 3
		if (sweep > 2*PI):
			sweep = 0
		
		Global.player.sweep_progres += SWEEP_SPD * delta
		
		rotation.z = sin(sweep)/PI
		var tween = create_tween()
		tween.tween_property(Global.player.sweep_box, "modulate:a", 1.0, 0.25)
	else:
		var tween = create_tween()
		tween.tween_property(Global.player.sweep_box, "modulate:a", 0.0, 0.25)
		
		if (is_held):
			rotation.z = lerp(rotation.z, 0.0, 0.05)
			sweep = lerp(sweep, 0.0, 0.05)
