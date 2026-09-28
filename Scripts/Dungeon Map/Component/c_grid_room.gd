extends Node
class_name C_Grid_Room

var grid_x: int = 0
var grid_y: int = 0
var grid_z: int = 0

var north_cell: C_Grid_Room = null
var east_cell: C_Grid_Room = null
var west_cell: C_Grid_Room = null
var south_cell: C_Grid_Room = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
