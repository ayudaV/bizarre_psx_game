extends Node3D

@onready var cutscene_handler: AnimationPlayer = $CutsceneHandler

func _ready() -> void:
	Global.pause = true
	Transition.color_rect.modulate.a = 1.0
	cutscene_handler.play("start")

func start():
	Transition.fade_out(2.3, init_tutorial_dialogue)

func init_tutorial_dialogue():
	var d = Global.player.dialogue_ui.dialogues.get_dialog("tutorial")
	Global.player.dialogue_ui.add_dialogue(d["dialogues"])
	Global.player.dialogue_ui.dialogue_end.connect(end_tutorial_dialogue)

func end_tutorial_dialogue():
	Global.pause = true
	Transition.fade_in(2.3, func():
		$npcs/tutorial_npc.queue_free()
		Global.player.quest_handler.add_quest("Jogue o lixo fora", 5)
		Global.current_quest = Global.quests.TRASH
		Transition.fade_out(2.3, func(): 
			Global.pause = false
			)
		)

	Global.player.dialogue_ui.dialogue_end.disconnect(end_tutorial_dialogue)
	
