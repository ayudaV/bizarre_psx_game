class_name Dialogue extends Resource

@export var dialogs := {}

func load_from_json(file_path : String):
	var data = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data)
	
	if parsed_data:
		dialogs = parsed_data
	else:
		print("error in parsing dialog from path: %s", file_path)

func get_npc_dialog(npc_id : String) -> Dictionary:
	if npc_id in dialogs: return dialogs[npc_id]
	else: return {}
