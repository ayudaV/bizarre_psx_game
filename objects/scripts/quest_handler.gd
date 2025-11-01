class_name QuestHandler extends Control

@onready var label: RichTextLabel = $MarginContainer/Label
@export var objectives : Array[String] = []
@export var progresses: Array[int] = []
@export var goals: Array[int] = []

signal quest_completed(name: String)

func _ready() -> void:
	render_text()

func _process(_delta: float) -> void:
	if (objectives.size() <= 0):
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
	else:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.5)

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("debug")):
		add_quest("Jogue o lixo fora", 1)

func add_quest(new: String, goal: int = -1):
	objectives.push_back(new)
	progresses.push_back(0)
	goals.push_back(goal)
	render_text()

func set_quests(new: Array[String]):
	objectives = new
	render_text()

func render_text():
	label.text = "[b]Objetivo:[/b] \n"
	for i in range(objectives.size()):
		label.text += "    -> " + objectives[i]
		
		if (goals[i] != -1):
			label.text += str(" [", progresses[i], "/", goals[i], "]")
		
		label.text += "\n"

func complete_quest(index: int = 0):
	if (objectives.size() <= 0):
		return
	
	quest_completed.emit(objectives[index].to_lower())
	objectives.remove_at(index)
	progresses.remove_at(index)
	goals.remove_at(index)
	render_text()

func has_quest(quest: String):
	for o in objectives:
		if (o.to_lower() == quest.to_lower()):
			return true
	
	return false

func progress_quest(index:int = 0, quantity: int = 1):
	if (objectives.size() <= 0): return
	
	progresses[index] = clamp(progresses[index] + quantity, 0, goals[index])
	if (progresses[index] == goals[index]):
		render_text()
		await get_tree().create_timer(1).timeout
		complete_quest(index)
		return
	
	render_text()

@warning_ignore("shadowed_variable_base_class")
func progress_quest_by_name(name: String, quantity: int = 1):
	if (objectives.size() <= 0): return
	var index = -1
	
	for i in range(objectives.size()):
		if (objectives[i].to_lower() == name.to_lower()):
			index = i
			break;
	
	progress_quest(index, quantity)
