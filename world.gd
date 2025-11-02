extends Node3D

@onready var cutscene_handler: AnimationPlayer = $CutsceneHandler
@onready var player: Player = $player
@onready var npc_dest: Node3D = $npc_dest
@onready var enemy_scene_controller: Node = $EnemySceneController

var can_clean_quest: bool

func _ready() -> void:
	Global.pause = true
	Transition.color_rect.modulate.a = 1.0
	player.quest_handler.quest_completed.connect(advance_quests)
	cutscene_handler.play("start")
	
	$Chase.timeout.connect($EnemySceneController.begin)
	
	$interactables/Wallet.picked.connect(func():
		if ($"npcs/npc??" != null): 
			$"npcs/npc??".queue_free()
			can_clean_quest = true
		)

func handle_quests():
	match Global.current_quest:
		Global.quests.NPC1:
			pass

func advance_quests(_name: String):
	Global.current_quest = (Global.current_quest + 1) as Global.quests
	
	match Global.current_quest:
		Global.quests.NPC1:
			player.quest_handler.add_quest("Expulse as pessoas da boate", 2)
			
			$npcs/npc01.dialogue_ui.dialogue_end.connect(func():
				player.quest_handler.progress_quest()
				advance_quests("npc_01")
				$npcs/npc01.focused = false
				$npcs/npc01.go_to(npc_dest.global_position, $npcs/npc01.queue_free)
				)
				
			$npcs/npc01.focused = true
		Global.quests.NPC2:
			$npcs/npc01.dialogue_ui.dialogue_end.disconnect($npcs/npc01.dialogue_ui.dialogue_end.get_connections()[0]["callable"])
		Global.quests.CLEAN:
			player.quest_handler.add_quest("Ache a vassoura")
			player.quest_handler.add_quest("Varra a pista")
			
			if ($Chase.is_stopped()):
				$Chase.start(60)

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
		await get_tree().create_timer(0.7).timeout
		$DJ.play()
		$DJ2.play()
		Transition.fade_out(2.3, func(): 
			Global.pause = false
			)
		)

	Global.player.dialogue_ui.dialogue_end.disconnect(end_tutorial_dialogue)

func _physics_process(_delta: float) -> void:
	handle_quests()
	#get_tree().call_group("enemy", "update_target_location", player.global_position)

func _on_npc_dissapear_area_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player") && can_clean_quest):
		can_clean_quest = false
		player.quest_handler.progress_quest()
		$Tension.play()
