extends Control

@onready var panel: Panel = $CanvasLayer/Panel
@onready var dialog_label: Label = $CanvasLayer/Panel/VBoxContainer/text
@onready var speaker_name: Label = $CanvasLayer/Panel/speaker_name
@onready var dialog_options: HBoxContainer = $CanvasLayer/Panel/options
@onready var skip_icon: TextureRect = $CanvasLayer/Panel/VBoxContainer/text/skip_icon

# dialog text
var dialog_text := []
var dialog_progress := 0.0
var dialog_limit : int
var dialog_spd := 40.0
var page := 0


func _ready() -> void:
	panel.visible = false

func _process(delta: float) -> void:	
	if panel.visible && Input.is_action_just_pressed("pass_dialog"):
		if dialog_progress >= dialog_limit: pass_dialogue()
		else: dialog_progress = dialog_limit
	
	if dialog_progress >= dialog_limit:
		skip_icon.modulate.a = lerp(skip_icon.modulate.a, 10.0, delta/3)
	else: skip_icon.modulate.a = 0
	
	if dialog_text.size() > 0:
		dialog_progress += delta * dialog_spd
		dialog_progress = clamp(dialog_progress, 0, dialog_limit)
		dialog_label.text = dialog_text[page].substr(0, round(dialog_progress)) 

func add_dialogue(name : String, dialog : Array, options : Array) -> void:
	Global.pause = true
	dialog_text += dialog
	speaker_name.text = name
	dialog_limit = dialog_text[page].length()
	panel.visible = true

func pass_dialogue():
	page += 1
	dialog_progress = 0
	
	if page >= dialog_text.size():
		panel.visible = false
		Global.pause = false
		Global.player.focus = null
		dialog_text = []
		page = 0
		return
	
	dialog_limit = dialog_text[page].length()
