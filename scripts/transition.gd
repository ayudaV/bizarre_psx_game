class_name Transitions extends Control

@onready var color_rect: ColorRect = $ColorRect

func fade_in(duration: float, callback: Callable = Callable()):
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	tween.tween_callback(callback)
	
func fade_out(duration: float, callback: Callable = Callable()):
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	tween.tween_callback(callback)
