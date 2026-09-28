extends Node3D
class_name C_Exploration_Map

var room_scene = preload("uid://d3phn7lggeyed")

@export var map_data_resource: Map_Data
@export var spacing_x: float = 1.0
@export var spacing_z: float = 1.0

@onready var grid_space: Node3D = $grid_space

var _room_grid: Array[Array]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_data_resource.calculate_room_data()
	var room_map = map_data_resource.map_grid
	
	for i in room_map.size():
		_room_grid.append([])
		for j in room_map[i].size():
			if room_map[i][j] == GlobalVariables.room_colours.keys()[0]:
				_room_grid[i].push_back(null)
			else:
				var room_colour = Global_Variables.room_colours.get(room_map[i][j])
				var room_instance = add_room(i, j, room_colour)
				_room_grid[i].push_back(room_instance)
	
	for i in _room_grid.size():
		for j in _room_grid[i].size():
			pass #TODO Update all Room Objects with their cardinal direction neighbours so they can update themselves

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_room(x: int, y: int, colour: GlobalVariables.room_colours) -> C_Room_Square:
	var new_room: C_Room_Square = room_scene.instantiate()
	grid_space.add_child(new_room)
	new_room.position.x += x * spacing_x
	new_room.position.z += y * spacing_z
	
	new_room.c_grid_room.grid_x = x
	new_room.c_grid_room.grid_y = y
	new_room.c_grid_room.grid_z = 0
	
	return new_room
