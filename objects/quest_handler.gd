class_name QuestHandler extends Control

@onready var label: RichTextLabel = $MarginContainer/Label
@export var objectives : Array[String] = []

func _ready() -> void:
	render_text()

func _process(_delta: float) -> void:
	if (objectives.size() <= 0):
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
	else:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.5)

func add_quest(new: String):
	objectives.push_back(new)
	render_text()

func set_quests(new: Array[String]):
	objectives = new
	render_text()

func render_text():
	label.text = "[b]Objetivo:[/b] \n"
	for o in objectives:
		label.text += "    -> " + o + "\n"

func complete_quest(index: int = 0):
	objectives.remove_at(index)
	render_text()
