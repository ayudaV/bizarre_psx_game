class_name Pickable extends RigidBody3D

@export var item_name: String
@export var quest: Global.quests = Global.quests.DEFAULT
@export var deny_text: String = ""

var follow: Node3D
var can_interact: bool = true
var is_held: bool

signal picked()

func _process(_delta: float) -> void:
	if (is_held):
		can_interact = false
	
	if (follow != null):
		if (global_position.distance_to(follow.global_position) > 5):
			global_position = lerp(global_position, follow.global_position, 0.2)
		else:
			global_position = follow.global_position

func _on_interact():
	pass

func interact():
	if (quest != Global.quests.DEFAULT && quest != Global.current_quest):
		Global.player.dialogue_ui.add_dialogue({
			"text": [["", deny_text]]
			})
		return
	
	if (can_interact && Global.player.can_hold):
		$AudioStreamPlayer.play()
		Global.player.hold_obj(item_name, self)
		_on_interact()
		emit_signal("unfocused")
