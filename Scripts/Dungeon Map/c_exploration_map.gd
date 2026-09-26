extends Node3D
class_name C_Exploration_Map

var room_scene = preload("uid://d3phn7lggeyed")

@export var grid_x = 10
@export var grid_y = 10

@onready var grid_space: Node3D = $grid_space

var _room_grid: Array[Array]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in grid_x:
		_room_grid.append([])
		for j in grid_y:
			_room_grid[i].push_back(null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
