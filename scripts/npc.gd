extends CharacterBody3D

@export_category("Properties")
@export var npc_id := "default"
@export var npc_name := "Fulano"

@export_category("Dialogue")
@export var dialogue_resource : Dialogue
@export var dialogue_ui : Control

@onready var head: CollisionShape3D = $head

func _ready() -> void:
	dialogue_resource.load_from_json("res://dialogue/dialogues.json")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func interact():
	var npc_dialogues = dialogue_resource.get_npc_dialog(npc_id)
	if npc_dialogues.is_empty(): return
	
	Global.player.focus = head
	dialogue_ui.add_dialogue(npc_name, npc_dialogues["dialogues"]["text"], [])
