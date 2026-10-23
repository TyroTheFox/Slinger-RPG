extends Node3D
class_name C_Player_Map_Avatar

@onready var avatar_grid_movement_component: C_Avatar_Grid_Movement = $c_avatar_grid_movement
@onready var avatar_grid_navigation_component: C_Avatar_Grid_Navigation = $c_avatar_grid_navigation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CrabbyConsole.add_custom_command("print_current_room", func(): print(get_current_room()))

	avatar_grid_movement_component.player_map_avatar_component = self
	avatar_grid_navigation_component.player_map_avatar_component = self

func set_up(spacing_x: float, spacing_z: float, full_grid_width: float, full_grid_height: float):
	avatar_grid_movement_component.spacing_x = spacing_x
	avatar_grid_movement_component.spacing_z = spacing_z
	avatar_grid_movement_component.full_grid_width = full_grid_width
	avatar_grid_movement_component.full_grid_height = full_grid_height

func set_room_grid(_room_grid: Array[Array]):
	avatar_grid_navigation_component.room_grid = _room_grid

func set_room_list(_room_list: Array[Dictionary], _square_list: Array[C_Room_Square]):
	avatar_grid_navigation_component.room_list = _room_list
	avatar_grid_navigation_component.square_list = _square_list

func set_grid_position(new_position: Vector2i):
	avatar_grid_movement_component.set_position(new_position)

func get_grid_position() -> Vector2i:
	return avatar_grid_movement_component.grid_position

func move_by(move_vector: Vector2i):
	avatar_grid_movement_component.move_target_by(move_vector, true)

func check_valid_grid_navigation() -> bool:
	return avatar_grid_navigation_component.check_for_valid_navigation(avatar_grid_movement_component.grid_position, avatar_grid_movement_component.grid_target)

# If found, returns Room Data. If not found, returns Dictionary with an ID set to -1. MAKE SURE YOU CHECK FOR THIS!!
func get_current_room() -> Dictionary:
	var room_data = get_room_position_is_in(get_grid_position())

	return room_data

# If found, returns Room Data. If not found, returns Dictionary with an ID set to -1. MAKE SURE YOU CHECK FOR THIS!!
func get_room_position_is_in(grid_position: Vector2i) -> Dictionary:
	var room_data = avatar_grid_navigation_component.get_room_position_is_in(grid_position)

	return room_data