extends Control
class_name Room_Grid_Overlay_Square

@onready var shape: Polygon2D = $shape
@export var room_colour: GlobalVariables.room_colours = GlobalVariables.room_colours.NULL:
	set(value):
		room_colour = value
		
		change_shape_colour()

var grid_x = 0
var grid_y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_shape_colour()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_shape_colour():
	var colour_value = GlobalVariables.room_colour_values.get(room_colour)
	
	shape.color = colour_value
