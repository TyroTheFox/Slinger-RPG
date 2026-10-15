extends Node
class_name G_Player_Manager

var player_data: R_Player_Resource

func create_player_data(player_name: String):
	player_data = R_Player_Resource.new()

func save_data():
	var player_name = player_data.player_name
	var file_path: String = GlobalVariables.save_file_path + player_name + ".tres"
	
	ResourceSaver.save(player_data, file_path)

func load_data(data_name: String) -> bool:
	var file_path: String = GlobalVariables.save_file_path + data_name + ".tres"
	
	var saved_data: R_Player_Resource = load(file_path)
	
	if saved_data:
		player_data = saved_data
		return true
	
	return false
