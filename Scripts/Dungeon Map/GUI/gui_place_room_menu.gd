extends Control
class_name GUI_Place_Room_Menu

@onready var add_l_shape_room: Button = $add_L_shape_room

func _on_add_l_shape_room_pressed() -> void:
	get_tree().call_group("Room_Map_Overlay", "add_shape_to_interaction_space", 0, 0, GlobalVariables.room_colours.RED, "L")
	add_l_shape_room.visible = false
