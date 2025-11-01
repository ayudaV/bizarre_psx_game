extends Area3D

func interact():
	if (Global.player.get("holding_obj") != null && Global.player.holding_obj.get("item_name") == "trash"):
		Global.player.delete_item()
