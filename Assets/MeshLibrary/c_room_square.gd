extends MeshInstance3D

@export var room_colour: GlobalVariables.room_colours = GlobalVariables.room_colours.RED

@onready var north_wall: MeshInstance3D = $north_wall
@onready var east_wall: MeshInstance3D = $east_wall
@onready var south_wall: MeshInstance3D = $south_wall
@onready var west_wall: MeshInstance3D = $west_wall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
