extends Control
class_name Room_Grid_Map_Square

@onready var shape: Polygon2D = $shape
@export var room_colour: GlobalVariables.room_colours = GlobalVariables.room_colours.NULL:
	set(value):
		room_colour = value
		
		change_shape_colour()

var grid_position: Vector2i = Vector2i(0, 0)

var square_width: float = 0
var square_height: float = 0
var spacing_x: float = 0
var spacing_y: float = 0
var full_grid_width: int = 0
var full_grid_height: int = 0

var full_space_width: float = 0
var full_space_height: float = 0

func set_up(_grid_x: int, _grid_y: int, _square_width: float, _square_height: float, x_spacing: float, y_spacing: float, _full_grid_width: int, _full_grid_height: int):
	grid_position.x = _grid_x
	grid_position.y = _grid_y
	
	square_width = _square_width
	square_height = _square_height
	spacing_x = x_spacing
	spacing_y = y_spacing
	full_grid_width = _full_grid_width
	full_grid_height = _full_grid_height
	
	full_space_width = (square_width + spacing_x) * full_grid_width
	full_space_height = (square_height + spacing_y) * full_grid_height
	
	update_position()

func change_shape_colour():
	var colour_value = GlobalVariables.room_colour_values.get(room_colour)
	
	shape.color = colour_value

func update_position():
	var x_position = grid_position.x * (square_width + spacing_x)
	var y_position = grid_position.y * (square_height + spacing_y)
	var grid_offset_x = full_space_width * 0.5
	var grid_offset_y = full_space_height * 0.5
	
	position.x = 0
	position.y = 0
	
	position.x += x_position - grid_offset_x
	position.y += y_position - grid_offset_y

func move_to(x: int, y: int):
	grid_position.x = x
	grid_position.y = y
	
	update_position()

func move_by(x_amount: int, y_amount: int):
	grid_position.x += x_amount
	grid_position.y += y_amount
	
	update_position()
