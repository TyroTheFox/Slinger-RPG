extends Node3D
class_name C_Room_Square

@export var room_colour: GlobalVariables.room_colours = GlobalVariables.room_colours.RED

@onready var north_wall: MeshInstance3D = $floor/north_wall
@onready var east_wall: MeshInstance3D = $floor/east_wall
@onready var south_wall: MeshInstance3D = $floor/south_wall
@onready var west_wall: MeshInstance3D = $floor/west_wall

@onready var c_grid_room: C_Grid_Room = $C_Grid_Room

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func calculate_room_walls():
	pass
