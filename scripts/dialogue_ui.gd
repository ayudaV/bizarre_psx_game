class_name DialogueUI extends Control

@onready var panel: CanvasLayer = $CanvasLayer
@onready var dialog_label: RichTextLabel = $CanvasLayer/VBoxContainer/Panel/MarginContainer/VBoxContainer/text
@onready var options: HBoxContainer = $CanvasLayer/VBoxContainer/options
@onready var skip_icon: TextureRect = $CanvasLayer/VBoxContainer/Panel/MarginContainer/VBoxContainer/text/skip_icon

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const DIALOGUE_OPTION = preload("uid://behc8v4xmek4q")
const SOUND_DELAY := 1

var sound_count: float = SOUND_DELAY

# dialog text
var dialogue_options: Dictionary
var dialog_text := []
var dialog_progress := 0.0
var dialog_limit : int
var dialog_spd := 40.0
var page := 0
var names := []

var dialogues: Dialogue = Dialogue.new()

signal dialogue_end()

var selected_option: int = 0:
	set(value):
		value = clamp(value, 0, options.get_child_count()-1)
		options.get_child(selected_option).selected = false
		options.get_child(value).selected = true
		selected_option = value

var can_choose: bool

func _ready() -> void:
	panel.visible = false
	dialogues.load_from_json("res://dialogue/dialogues.json")

func _process(delta: float) -> void:
	if !panel.visible:
		return
	
	if Input.is_action_just_pressed("pass_dialog"):
		if dialog_progress >= dialog_limit: pass_dialog()
		else: dialog_progress = dialog_limit
	
	if dialog_progress >= dialog_limit:
		skip_icon.modulate.a = lerp(skip_icon.modulate.a, 10.0, delta/3)
		sound_count = 0
		_handle_option_choose()
	else:
		sound_count += 1/dialog_spd
		if (sound_count > SOUND_DELAY):
			audio_stream_player.play()
			sound_count = 0
		skip_icon.modulate.a = 0
	
	if dialog_text.size() > 0:
		dialog_progress += delta * dialog_spd
		dialog_progress = clamp(dialog_progress, 0, dialog_limit)
		dialog_label.visible_characters = int(dialog_progress)
		

func _handle_option_choose():
	if (options.get_child_count() <= 0):
		return
	
	if (!can_choose):
		options.get_child(0).selected = true
		can_choose = true
		
	selected_option += (int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left")))

func add_dialogue(dialogue: Dictionary) -> void:
	Global.pause = true

	var texts = dialogue.get("text")
	var d_options = dialogue.get("options")
	if (d_options == null):
		d_options = {}

	for d in texts:
		dialog_text.push_back(str("[b]" + d[0] + ":[/b] " if d[0] != "" else "", d[1]))
		names.push_back(d[0])
	
	dialogue_options = d_options.duplicate()
	
	if (dialog_text.size() == texts.size()):
		dialog_label.text = dialog_text[0]
	
	if (dialog_text.size() <= page-1):
		render_options()
	
	dialog_limit = dialog_text[page].length()
	panel.visible = true

func render_options():
	for c in options.get_children():
		c.queue_free()
	
	if (dialogue_options.keys().size() <= 0 || page < dialog_text.size()-1):
		return
	
	for o in dialogue_options.keys():
		var option_node = DIALOGUE_OPTION.instantiate()
		option_node.text = o
		options.add_child(option_node)

func pass_dialog():
	page += 1
	dialog_progress = 0
	can_choose = false
	
	if page >= dialog_text.size():	
		panel.visible = false
		Global.pause = false
		Global.player.focus = null
		dialog_text.clear()
		page = 0
		
		if (options.get_child_count() > 0 && !dialogues.get_dialog(dialogue_options[options.get_child(selected_option).text]).is_empty()):
			var next = dialogues.get_dialog(dialogue_options[options.get_child(selected_option).text])
			dialogue_options.clear()
			add_dialogue(next["dialogues"])
		else:
			dialogue_end.emit()
	
		for c in options.get_children():
			c.queue_free()

		return
	
	if (dialog_text.size()  <= page - 1):
		render_options()

	render_options()
	dialog_label.text = dialog_text[page]
	dialog_limit = dialog_text[page].length()
