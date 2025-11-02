extends Node

var ui_context : ContextComponent
var player : Player
var camera : Camera3D
var hud : Control
var pause := false

enum quests {
	DEFAULT,
	TRASH,
	PERSON,
	CLEAN
}

var current_quest: quests = quests.DEFAULT
