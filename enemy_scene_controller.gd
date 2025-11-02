extends Node

signal Jumpscare

@onready var player: Player = $"../player"
@onready var enemy: CharacterBody3D = $Enemy
@onready var initial_enemy_position: Node3D = $InitialEnemyPosition
@onready var sound_player: AudioStreamPlayer3D = $Enemy/SoundPlayer
@onready var knocking: AudioStreamPlayer3D = $Knocking

const CHASING_SOUND = preload("res://sounds/chasing_sound.mp3")
const KNOCKING = preload("res://sounds/knocking.mp3")

var is_chasing = false
var waiting_time = 15.0
var should_start_count_down = false

var knock_count = 0

func _ready() -> void:
	Jumpscare.connect(_on_jumpscared_triggered)
	
func begin():
	enemy.visible = true
	knocking.stream = KNOCKING
	knocking.play()
	
	should_start_count_down = true


func enter_scene():
	sound_player.stream = CHASING_SOUND
	sound_player.play()
	knocking.stop()
	
	var tween = create_tween()

	tween.tween_property(
		enemy,
		"global_position",
		initial_enemy_position.global_position,
		1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await tween.finished

	is_chasing = true


func _process(delta: float) -> void:
	if should_start_count_down:
		waiting_time -= delta

		if waiting_time <= 0:
			should_start_count_down = false
			enter_scene()

	if is_chasing:
		get_tree().call_group("enemy", "update_target_location", player.global_position)

func _on_jumpscared_triggered():
	get_tree().change_scene_to_file("res://scenes/Jumpscare.tscn")
