extends Control
class_name Room_Grid_Overlay

const room_grid_square_scene = preload("uid://ch2el8blewc0m")
const room_grid_choice_shape_scene = preload("uid://qgmsfpj4wc44")

@onready var grid_space: Control = $grid_space
@onready var interaction_space: Control = $interaction_space

@export var square_width: float = 30.0
@export var square_height: float = 30.0
@export var spacing_x: float = 1.0
@export var spacing_y: float = 1.0

## Left Movement
@export var key_bind_left: String = "ui_left"
## Right Movement
@export var key_bind_right: String = "ui_right"
## Up Movement
@export var key_bind_up: String = "ui_up"
## Down Movement
@export var key_bind_down: String = "ui_down"
## Attack Movement
@export var key_bind_attack: String = "ui_accept"

var map_node: C_Exploration_Map = null
var _room_grid: Array[Array] = []
var _interaction_shape: Room_Grid_Choice_Shape = null

var full_grid_width = 0
var full_grid_height = 0 

var full_space_width: float = 0
var full_space_height: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	var left_pushed = event.get_action_strength(key_bind_left) > 0 
	var right_pushed = event.get_action_strength(key_bind_right) > 0
	var up_pushed = event.get_action_strength(key_bind_up) > 0
	var down_pushed = event.get_action_strength(key_bind_down) > 0
	
	if left_pushed and not right_pushed:
		_interaction_shape.move_by(-1, 0)
	
	if right_pushed and not left_pushed:
		_interaction_shape.move_by(1, 0)
	
	if up_pushed and not down_pushed:
		_interaction_shape.move_by(0, -1)
	
	if down_pushed and not up_pushed:
		_interaction_shape.move_by(0, 1)

func display_overlay():
	visible = true

func hide_overlay():
	visible = false

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
		"L",
		square_width, square_height,
		spacing_x, spacing_y,
		full_grid_width, full_grid_height
	)
	
	new_shape.room_colour = colour
	
	_interaction_shape = new_shape
	
	return new_shape

func remove_shape_from_interaction_space():
	_interaction_shape.queue_free()
	_interaction_shape = null
