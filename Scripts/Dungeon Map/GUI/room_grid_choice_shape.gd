extends Control
class_name Room_Grid_Choice_Shape

enum SHAPE_ROTATE_DIRECTION {
	LEFT,
	RIGHT
}

enum SHAPE_ROTATION_STATE {
	ZERO,
	NINETY,
	ONE_EIGHTY,
	TWO_SEVENTY
}

const room_grid_choice_square = preload("uid://kv5x3kmqgf7v")

var current_rotation_state: SHAPE_ROTATION_STATE = SHAPE_ROTATION_STATE.ZERO

@export var room_colour: GlobalVariables.room_colours = GlobalVariables.room_colours.NULL:
	set(value):
		room_colour = value
		
		square_list.map(func(square): square.room_colour = room_colour)

var grid_position: Vector2i = Vector2i(0, 0)

var shape_data: Room_Grid_Shape_Data

var square_width: float = 0
var square_height: float = 0
var spacing_x: float = 0
var spacing_y: float = 0
var full_grid_width: int = 0
var full_grid_height: int = 0

var shape_grid: Array[Array] = []
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
	
	shape_data = GlobalVariables.room_shape_data.get(shape_data_key)
	
	square_width = _square_width
	square_height = _square_height
	spacing_x = x_spacing
	spacing_y = y_spacing
	full_grid_width = _full_grid_width
	full_grid_height = _full_grid_height
	
	grid_position.x = initial_x
	grid_position.y = initial_y
	
	create_shape(shape_data)

func create_shape(shape_data: Room_Grid_Shape_Data):
	for grid_x in shape_data.shape_grid.size():
		for grid_y in shape_data.shape_grid[grid_x].size():
			var data: bool = shape_data.shape_grid[grid_x][grid_y]
			
			if data:
				add_square_to_shape(grid_x, grid_y, self)
				shape_grid = shape_data.shape_grid

func rotate_shape(rotate_direction: SHAPE_ROTATE_DIRECTION):
	#for i in square_list.size():
		## Attempting to mitigate the reordering and reshuffling that popping
		## array elements cause by attempting to pop from the end of the array first.
		## Hopefully avoids the reshuffling and we can use array popping without
		## major issues.
		#var reversedIndex = (square_list.size() - 1) - i
		#remove_square_from_shape(reversedIndex)
	#
	#create_shape(shape_data)
	
	var pivot_square_position = square_position_list.get(shape_data.pivot_square)
	
	var relative_positions = []
	
	for i in square_list.size():
		var square_position = square_position_list.get(i)
		
		var relative_x = square_position.x - pivot_square_position.x
		var relative_y = square_position.y - pivot_square_position.y
		
		relative_positions.push_back(Vector2i(relative_x, relative_y))
	
	var rotated_relative_positions = relative_positions.duplicate(true)
	
	for y in 
	
	pass
	
	#for 
		#var new_x = 0
		#var new_y = 0
		#
		#match(rotate_direction):
			#SHAPE_ROTATE_DIRECTION.RIGHT:
				#new_x = pivot_square_position.y + (relative_y * -1) 
				#new_y = pivot_square_position.x + relative_x
			#SHAPE_ROTATE_DIRECTION.LEFT:
				#new_x = pivot_square_position.y + relative_y
				#new_y = pivot_square_position.x + (relative_x + -1)
		#
		#square_position_list[i].x = new_x
		#square_position_list[i].y = new_y
		#
		#update_square_position(i)

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

func remove_square_from_shape(shape_index: int):
	var square_shape = square_list.pop_at(shape_index)
	square_position_list.pop_at(shape_index)
	
	square_shape.queue_free()

func update_position():
	for i in square_list.size():
		update_square_position(i)

func update_square_position(square_index: int):
	var square = square_list[square_index]
	var local_shape_position = square_position_list[square_index]
	square.move_to(local_shape_position.x + grid_position.x, local_shape_position.y + grid_position.y)

func move_to(x: int, y: int):
	grid_position.x = x
	grid_position.y = y
	
	update_position()

func move_by(x_amount: int = 0, y_amount: int = 0):
	grid_position.x += x_amount
	grid_position.y += y_amount
	
	update_position()
