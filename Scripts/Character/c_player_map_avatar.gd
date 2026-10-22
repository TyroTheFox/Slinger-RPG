extends Node3D
class_name C_Player_Map_Avatar

@onready var avatar_grid_movement_component: C_Avatar_Grid_Movement = $c_avatar_grid_movement
@onready var avatar_grid_navigation_component: C_Avatar_Grid_Navigation = $c_avatar_grid_navigation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	avatar_grid_movement_component.player_map_avatar_component = self
	avatar_grid_navigation_component.player_map_avatar_component = self

func set_up(spacing_x: float, spacing_z: float, full_grid_width: float, full_grid_height: float):
	avatar_grid_movement_component.spacing_x = spacing_x
	avatar_grid_movement_component.spacing_z = spacing_z
	avatar_grid_movement_component.full_grid_width = full_grid_width
	avatar_grid_movement_component.full_grid_height = full_grid_height

func set_room_grid(_room_grid: Array[Array]):
	avatar_grid_navigation_component.room_grid = _room_grid

func set_grid_position(new_position: Vector2i):
	avatar_grid_movement_component.set_position(new_position)

func move_by(move_vector: Vector2i):
	avatar_grid_movement_component.move_target_by(move_vector, true)

func check_valid_grid_navigation() -> bool:
	return avatar_grid_navigation_component.check_for_valid_navigation(avatar_grid_movement_component.grid_position, avatar_grid_movement_component.grid_target)