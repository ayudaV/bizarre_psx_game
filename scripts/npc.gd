extends CharacterBody3D

func interact():
	print("poggers")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
