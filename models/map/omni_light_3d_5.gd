extends OmniLight3D

var flicker_intensity := 30
var flicker_speed := 10.0
var flicker_strength := 20

func _process(delta: float) -> void:
	# Create a random flicker effect
	var noise = randf_range(-flicker_strength, flicker_strength)
	light_energy = flicker_intensity + noise * sin(Time.get_ticks_msec() / 100.0 * flicker_speed)
