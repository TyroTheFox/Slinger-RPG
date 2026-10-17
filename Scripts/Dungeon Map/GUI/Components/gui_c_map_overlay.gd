extends Node
class_name GUI_C_Map_Overlay

const room_grid_square_scene = preload("uid://ch2el8blewc0m")

@onready var grid_space: Control = $room_grid_overlay/grid_space

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
