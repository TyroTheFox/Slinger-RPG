extends Node3D
class_name C_Player_Map_Avatar

@onready var avatar_grid_movement_component: C_Avatar_Grid_Movement = $c_avatar_grid_movement 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	avatar_grid_movement_component.player_map_avatar_component = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_up(spacing_x: float, spacing_z: float, full_grid_width: float, full_grid_height: float):
	avatar_grid_movement_component.spacing_x = spacing_x
	avatar_grid_movement_component.spacing_z = spacing_z
	avatar_grid_movement_component.full_grid_width = full_grid_width
	avatar_grid_movement_component.full_grid_height = full_grid_height

func set_grid_position(new_position: Vector2i):
	avatar_grid_movement_component.set_position(new_position)

func move_by(move_vector: Vector2i):
	avatar_grid_movement_component.move_target_by(move_vector, true)