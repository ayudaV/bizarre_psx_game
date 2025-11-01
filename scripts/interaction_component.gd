class_name InteractionComponent extends Node

var parent : Node

@export var content := ""
@export var override_icon := false
@export var new_icon : Texture2D

func _ready() -> void:
	parent = get_parent()
	connect_parent()

func in_range():
	if parent.visible:
		if (parent.get("can_interact") == false):
			return
		
		Global.ui_context.update_text(content)

func not_in_range():
	Global.ui_context.reset()
 
func on_interact():
	if parent.visible && !Global.pause:
		parent.interact()

func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")
	parent.connect("focused", Callable(self, "in_range"))
	parent.connect("unfocused", Callable(self, "not_in_range"))
	parent.connect("interacted", Callable(self, "on_interact"))
