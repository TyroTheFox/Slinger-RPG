extends Control
class_name Room_Grid_Choice_Shape

const room_grid_choice_square = preload("uid://kv5x3kmqgf7v")

@export var room_colour: GlobalVariables.room_colours = GlobalVariables.room_colours.NULL:
	set(value):
		room_colour = value
		
		square_list.map(func(square): square.room_colour = room_colour)

var grid_position: Vector2i = Vector2i(0, 0)

var square_width: float = 0
var square_height: float = 0
var spacing_x: float = 0
var spacing_y: float = 0
var full_grid_width: int = 0
var full_grid_height: int = 0

var square_list: Array[Room_Grid_Map_Square] = []
var square_position_list: Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_up_shape(initial_x: int, initial_y: int, shape_data_key: String, _square_width: float, _square_height: float, x_spacing: float, y_spacing: float, _full_grid_width: int, _full_grid_height: int):
	if not GlobalVariables.room_shape_data.has(shape_data_key):
		return
	
	var shape_data: Room_Grid_Shape_Data = GlobalVariables.room_shape_data.get(shape_data_key)
	
	grid_position.x = initial_x
	grid_position.y = initial_y
	
	square_width = _square_width
	square_height = _square_height
	spacing_x = x_spacing
	spacing_y = y_spacing
	full_grid_width = _full_grid_width
	full_grid_height = _full_grid_height
	
	for x in shape_data.shape_grid.size():
		for y in shape_data.shape_grid[x].size():
			var data: bool = shape_data.shape_grid[x][y]
			
			if data:
				add_square_to_shape(x, y, self)

func add_square_to_shape(x: int, y: int, parent: Control) -> Room_Grid_Choice_Square:
	var new_square: Room_Grid_Choice_Square = room_grid_choice_square.instantiate()
	
	parent.add_child(new_square)
	new_square.set_up(
		grid_position.x + x, grid_position.y + y,
		square_width, square_height,
		spacing_x, spacing_y,
		full_grid_width, full_grid_height
	)
	
	new_square.room_colour = room_colour
	
	square_list.push_back(new_square)
	square_position_list.push_back(Vector2i(x, y))
	
	return new_square

func update_position():
	for i in square_list.size():
		var square = square_list[i]
		var local_shape_position = square_position_list[i]
		square.move_to(local_shape_position.x + grid_position.x, local_shape_position.y + grid_position.y)

func move_to(x: int, y: int):
	grid_position.x = x
	grid_position.y = y
	
	update_position()

func move_by(x_amount: int = 0, y_amount: int = 0):
	grid_position.x += x_amount
	grid_position.y += y_amount
	
	update_position()
