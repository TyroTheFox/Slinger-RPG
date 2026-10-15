extends Control
class_name GUI_Place_Room_Menu

func add_choice_shape_to_map(room_shape_name: String, room_colour: GlobalVariables.room_colours) -> void:
	get_tree().call_group("Room_Map_Overlay", "add_shape_to_interaction_space", 0, 0, room_colour, room_shape_name)

func _on_close_menu_pressed() -> void:
	get_tree().call_group("Room_Map_Overlay", "remove_shape_from_interaction_space")
	get_tree().call_group("Exploration_Scene_Event", "hide_overlay")
	get_tree().call_group("Dungeon_Map_Scene", "switch_back_to_explore_mode")
