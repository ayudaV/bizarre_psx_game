extends CharacterBody3D

@export_category("Properties")
@export var npc_id := "default"
@export var npc_name := "Fulano"

@export_category("Dialogue")
@export var dialogue_resource : Dialogue
@export var dialogue_ui : DialogueUI
@export var can_interact: bool = true

@onready var head: CollisionShape3D = $head

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
var current_on_target_reached = null
var SPEED = 6.0

func _ready() -> void:
	dialogue_resource.load_from_json("res://dialogue/dialogues.json")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not nav_agent.is_navigation_finished():
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var direction = next_location - current_location
		var new_velocity = direction.normalized() * SPEED
		
		if direction.length() > 0.1:
			var target_rotation = atan2(direction.x, direction.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, 5.0 * delta)
		
		velocity = velocity.move_toward(new_velocity, 0.25)
		move_and_slide()
		
func interact():
	var npc_dialogues := dialogue_resource.get_dialog(npc_id)
	if npc_dialogues.is_empty(): return
	
	Global.player.focus = head
	dialogue_ui.add_dialogue(npc_name, npc_dialogues["dialogues"]["text"], [])
	
func go_to(target_location, _on_target_reached):
	if Global.pause:
		return
	
	current_on_target_reached = _on_target_reached
	nav_agent.target_position = target_location


func _on_navigation_agent_3d_target_reached() -> void:
	if current_on_target_reached == null:
		return
		
	current_on_target_reached.call()
