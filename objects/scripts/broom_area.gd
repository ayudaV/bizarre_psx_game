class_name PickableArea extends Area3D

@onready var obj: Pickable = $".."

var can_interact: bool:
	get():
		return obj.can_interact

func interact():
	obj.interact()
