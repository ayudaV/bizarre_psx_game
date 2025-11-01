extends Area3D

@onready var broom: RigidBody3D = $".."

func interact():
	broom.interact()
