extends Control
class_name Room_Grid_Overlay

const room_grid_square_scene = preload("uid://ch2el8blewc0m")

@onready var grid_space: Control = $grid_space

@export var spacing_x: float = 20.0
@export var spacing_y: float = 20.0

var map_node: C_Exploration_Map = null
var _room_grid: Array[Array] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display_overlay():
	visible = true

func hide_overlay():
	visible = false

func process_room_data():
	var map_room_grid = map_node._room_grid
	
	for x in map_room_grid.size():
		_room_grid.append([])
		for y in map_room_grid[x].size():
			var grid_room: C_Room_Square = map_room_grid[x][y]
			
			if grid_room:
				var new_room_square = add_room(x, y, grid_room.room_colour)
				_room_grid[x].push_back(new_room_square)
			else:
				var new_room_square = add_room(x, y, GlobalVariables.room_colours.NULL)
				_room_grid[x].push_back(new_room_square)

func add_room(x: int, y: int, colour: GlobalVariables.room_colours) -> Room_Grid_Overlay_Square:
	var new_room: Room_Grid_Overlay_Square = room_grid_square_scene.instantiate()
	grid_space.add_child(new_room)
	new_room.position.x += x * spacing_x
	new_room.position.y += y * spacing_y
	
	new_room.grid_x = x
	new_room.grid_y = y
	
	new_room.room_colour = colour
	
	return new_room
