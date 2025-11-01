extends Area3D

var can_interact: bool = true


func interact():
	if (Global.player.get("holding_obj") != null && Global.player.holding_obj.get("item_name") == "trash"):
		Global.player.delete_obj()
		Global.player.quest_handler.progress_quest_by_name("jogue o lixo fora")
