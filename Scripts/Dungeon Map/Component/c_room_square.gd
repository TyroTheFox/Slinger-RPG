extends Node3D
class_name C_Room_Square

@export var room_colour: GlobalVariables.room_colours = GlobalVariables.room_colours.NULL:
	set(value):
		room_colour = value
		c_grid_room.room_colour = value
		
		change_room_meshes_colour()

@onready var floor: MeshInstance3D = $floor
@onready var north_wall: MeshInstance3D = $floor/north_wall
@onready var east_wall: MeshInstance3D = $floor/east_wall
@onready var south_wall: MeshInstance3D = $floor/south_wall
@onready var west_wall: MeshInstance3D = $floor/west_wall

@onready var c_grid_room: C_Grid_Room = $C_Grid_Room

var grouped_rooms: Array[C_Grid_Room] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	c_grid_room.room_colour = room_colour
	
	change_room_meshes_colour()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_room_meshes_colour():
	var colour_material = GlobalVariables.room_textures.get(room_colour)
	floor.mesh.surface_set_material(0, colour_material)
	north_wall.mesh.surface_set_material(0, colour_material)
	east_wall.mesh.surface_set_material(0, colour_material)
	south_wall.mesh.surface_set_material(0, colour_material)
	west_wall.mesh.surface_set_material(0, colour_material)

func calculate_room_walls():
	calculate_room_wall(c_grid_room.north_cell, north_wall)
	calculate_room_wall(c_grid_room.south_cell, south_wall)
	calculate_room_wall(c_grid_room.east_cell, east_wall)
	calculate_room_wall(c_grid_room.west_cell, west_wall)

func calculate_room_wall(cell: C_Grid_Room, wall: MeshInstance3D):
	if cell and cell.room_colour == room_colour:
		wall.visible = false
		grouped_rooms.push_back(cell)
	else:
		wall.visible = true
