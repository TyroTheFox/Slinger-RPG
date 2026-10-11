extends Control
class_name GUI_Place_Room_Menu

@onready var add_l_shape_room: Button = $add_L_shape_room
@onready var add_1x_1_shape_room: Button = $add_1x1_shape_room
@onready var add_1x_2_shape_room: Button = $add_1x2_shape_room
@onready var add_2x_2_shape_room: Button = $add_2x2_shape_room
@onready var add_2x_2_1x_1_shape_room: Button = $"add_2x2+1x1_shape_room"

func _on_add_l_shape_room_pressed() -> void:
	get_tree().call_group("Room_Map_Overlay", "add_shape_to_interaction_space", 0, 0, GlobalVariables.room_colours.RED, "L")
	add_l_shape_room.visible = false

func _on_add_1x_1_shape_room_pressed() -> void:
	get_tree().call_group("Room_Map_Overlay", "add_shape_to_interaction_space", 0, 0, GlobalVariables.room_colours.RED, "1x1")
	add_1x_1_shape_room.visible = false

func _on_add_1x_2_shape_room_pressed() -> void:
	get_tree().call_group("Room_Map_Overlay", "add_shape_to_interaction_space", 0, 0, GlobalVariables.room_colours.RED, "1x2")
	add_1x_2_shape_room.visible = false

func _on_add_2x_2_shape_room_pressed() -> void:
	get_tree().call_group("Room_Map_Overlay", "add_shape_to_interaction_space", 0, 0, GlobalVariables.room_colours.RED, "2x2")
	add_2x_2_shape_room.visible = false

func _on_add_2x_21x_1_shape_room_pressed() -> void:
	get_tree().call_group("Room_Map_Overlay", "add_shape_to_interaction_space", 0, 0, GlobalVariables.room_colours.RED, "2x2+1x1")
	add_2x_2_1x_1_shape_room.visible = false
