extends Node
class_name GUI_C_Map_Interaction

@export var room_grid_controls_component: GUI_C_Room_Grid_Controls

var explortation_gui_controller: Exploration_GUI_Controller = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_grid_controls_component.move_shape.connect(_on_choice_shape_move)
	room_grid_controls_component.rotate_shape.connect(_on_choice_shape_rotate)
	room_grid_controls_component.confirm_choice.connect(_on_choice_shape_confirm)
	room_grid_controls_component.cancel_choice.connect(_on_choice_shape_cancel)

func confirm_chosen_room_choice():
	if not explortation_gui_controller.interaction_shape:
		return
	
	var interaction_shape = explortation_gui_controller.interaction_shape
	var choice_position = interaction_shape.grid_position
	var square_position_list = interaction_shape.square_position_list
	var chosen_room_colour =  interaction_shape.room_colour

	if not check_choice_position_is_in_bounds(choice_position, square_position_list):
		get_tree().call_group("Exploration_Scene_Event", "show_shape_out_of_bounds_message")
		return
	
	if not check_choice_position_is_not_covering_existing_rooms(choice_position, square_position_list):
		get_tree().call_group("Exploration_Scene_Event", "show_shape_covers_another_room_message")
		return
	
	for square_position in square_position_list:
		get_tree().call_group("Exploration_Scene_Event", "add_room_to_map", choice_position.x + square_position.x, choice_position.y + square_position.y, chosen_room_colour)
	
	get_tree().call_group("Room_Map", "add_room", choice_position, square_position_list, chosen_room_colour)
	
	get_tree().call_group("Exploration_Scene_Event", "remove_shape_from_interaction_space")
	get_tree().call_group("Exploration_Scene_Event", "remove_used_card")
	#remove_shape_from_interaction_space()
	get_tree().call_group("Exploration_Scene_Event", "show_card_menu")

func check_choice_position_is_in_bounds(choice_position: Vector2i, square_position_list: Array[Vector2i]) -> bool:
	var invalid_square_found: bool = false

	for square_position in square_position_list:
		var square_x: int = choice_position.x + square_position.x
		var square_y: int = choice_position.y + square_position.y

		invalid_square_found = (square_x < 0 or square_x >= explortation_gui_controller.full_grid_width) or (square_y < 0 or square_y >= explortation_gui_controller.full_grid_height)

		if invalid_square_found:
			break

	return not invalid_square_found

func check_choice_position_is_not_covering_existing_rooms(choice_position: Vector2i, square_position_list: Array[Vector2i]) -> bool:
	var invalid_square_found: bool = false

	for square_position in square_position_list:
		var square_x: int = choice_position.x + square_position.x
		var square_y: int = choice_position.y + square_position.y

		var room_square: Room_Grid_Map_Square = explortation_gui_controller.room_grid[square_x][square_y]
			
		invalid_square_found = room_square.room_colour != Global_Variables.room_colours.NULL

		if invalid_square_found:
			break

	return not invalid_square_found

func _on_choice_shape_move(move_x: int, move_y: int):
	if explortation_gui_controller.interaction_shape: 
		explortation_gui_controller.interaction_shape.move_by(move_x, move_y)

func _on_choice_shape_rotate(rotation_direction: Room_Grid_Choice_Shape.SHAPE_ROTATE_DIRECTION): 
	if explortation_gui_controller.interaction_shape: 
		explortation_gui_controller.interaction_shape.rotate_shape(rotation_direction)

func _on_choice_shape_confirm():
	if explortation_gui_controller.interaction_shape:
		confirm_chosen_room_choice()

func _on_choice_shape_cancel():
	if explortation_gui_controller.interaction_shape:
		var used_card_data = explortation_gui_controller.used_card_data

		get_tree().call_group("Exploration_Scene_Event", "remove_used_card")
		PlayerManager.player_data.add_room_card(used_card_data.name, used_card_data.colour)
		# clear_used_card_data()
		# remove_shape_from_interaction_space()
		get_tree().call_group("Exploration_Scene_Event", "remove_shape_from_interaction_space")
		get_tree().call_group("Exploration_Scene_Event", "show_card_menu")
