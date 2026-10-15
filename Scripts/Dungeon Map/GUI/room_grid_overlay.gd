extends Control
class_name Room_Grid_Overlay

const room_grid_square_scene = preload("uid://ch2el8blewc0m")
const room_grid_choice_shape_scene = preload("uid://qgmsfpj4wc44")

@onready var grid_space: Control = $grid_space
@onready var interaction_space: Control = $interaction_space
@onready var room_grid_controls_component: C_GUI_Room_Grid_Controls = $c_gui_room_grid_controls

@export var square_width: float = 30.0
@export var square_height: float = 30.0
@export var spacing_x: float = 1.0
@export var spacing_y: float = 1.0

var map_node: C_Exploration_Map = null
var _room_grid: Array[Array] = []
var _interaction_shape: Room_Grid_Choice_Shape = null

var full_grid_width = 0
var full_grid_height = 0 

var full_space_width: float = 0
var full_space_height: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_grid_controls_component.move_shape.connect(_on_choice_shape_move)
	room_grid_controls_component.rotate_shape.connect(_on_choice_shape_rotate)
	room_grid_controls_component.confirm_choice.connect(_on_choice_shape_confirm)
	room_grid_controls_component.cancel_choice.connect(_on_choice_shape_cancel)

func process_room_data():
	var map_room_grid = map_node._room_grid
	
	full_grid_width = map_room_grid.size()
	full_grid_height = map_room_grid[0].size()
	
	full_space_width = full_grid_width * (square_width + spacing_x)
	full_space_height = full_grid_height * (square_height + spacing_y)
	
	for x in full_grid_width:
		_room_grid.append([])
		for y in map_room_grid[x].size():
			var grid_room: C_Room_Square = map_room_grid[x][y]
			
			if grid_room:
				var new_room_square = add_room_to_map(x, y, grid_room.room_colour)
				_room_grid[x].push_back(new_room_square)
			else:
				var new_room_square = add_room_to_map(x, y, GlobalVariables.room_colours.NULL)
				_room_grid[x].push_back(new_room_square)

func add_room_to_map(x: int, y: int, colour: GlobalVariables.room_colours) -> Room_Grid_Map_Square:
	var new_room: Room_Grid_Map_Square = room_grid_square_scene.instantiate()
	grid_space.add_child(new_room)
	new_room.set_up(
		x, y,
		square_width, square_height,
		spacing_x, spacing_y,
		full_grid_width, full_grid_height
	)
	
	new_room.room_colour = colour
	
	return new_room

func add_shape_to_interaction_space(x: int, y: int, colour: GlobalVariables.room_colours, shape_data_key: String) -> Room_Grid_Choice_Shape:
	if not GlobalVariables.room_shape_data.has(shape_data_key):
		return
	
	var new_shape: Room_Grid_Choice_Shape = room_grid_choice_shape_scene.instantiate()
	
	interaction_space.add_child(new_shape)
	new_shape.set_up_shape(
		x, y, 
		shape_data_key,
		square_width, square_height,
		spacing_x, spacing_y,
		full_grid_width, full_grid_height
	)
	
	new_shape.room_colour = colour
	
	_interaction_shape = new_shape
	
	return new_shape

func confirm_chosen_room_choice():
	if not _interaction_shape:
		return
	
	var choice_position = _interaction_shape.grid_position
	var square_position_list = _interaction_shape.square_position_list
	var chosen_room_colour =  _interaction_shape.room_colour
	
	for square_position in square_position_list:
		add_room_to_map(choice_position.x + square_position.x, choice_position.y + square_position.y, chosen_room_colour)
	
	get_tree().call_group("Room_Map", "add_room", choice_position, square_position_list, chosen_room_colour)
	
	remove_shape_from_interaction_space()

func remove_shape_from_interaction_space():
	if not _interaction_shape:
		return
	
	_interaction_shape.queue_free()
	_interaction_shape = null

#/// EVENT FUNCTIONS ///
func _on_choice_shape_move(move_x: int, move_y: int): 
	if _interaction_shape: 
		_interaction_shape.move_by(move_x, move_y)

func _on_choice_shape_rotate(rotation_direction: Room_Grid_Choice_Shape.SHAPE_ROTATE_DIRECTION): 
	if _interaction_shape: 
		_interaction_shape.rotate_shape(rotation_direction)

func _on_choice_shape_confirm():
	if _interaction_shape:
		confirm_chosen_room_choice()

func _on_choice_shape_cancel():
	if _interaction_shape:
		remove_shape_from_interaction_space()
