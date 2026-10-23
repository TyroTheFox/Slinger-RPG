extends Control
class_name GUI_Place_Room_Menu

func _on_close_menu_pressed() -> void:
	get_tree().call_group("Exploration_Scene", "switch_back_to_explore_mode")
