extends Node
class_name C_Avatar_Grid_Navigation

var player_map_avatar_component: C_Player_Map_Avatar = null

var room_grid: Array[Array] = []

func check_for_valid_navigation(current_position: Vector2i, target_position: Vector2i) -> bool:
	var valid_target: bool = false

	var current_room_instance: C_Room_Square = room_grid[current_position.x][current_position.y]

	var is_target_north = target_position.y < current_position.y
	var is_target_south = target_position.y > current_position.y
	var is_target_east = target_position.x > current_position.x
	var is_target_west = target_position.x < current_position.x

	var north_wall_up = current_room_instance.north_wall.visible
	var south_wall_up = current_room_instance.south_wall.visible
	var east_wall_up = current_room_instance.east_wall.visible
	var west_wall_up = current_room_instance.west_wall.visible

	if is_target_north or is_target_south:
		if is_target_north and not is_target_south:
			valid_target = not north_wall_up
		if not is_target_north and is_target_south:
			valid_target = not south_wall_up
	else:
		if is_target_east and not is_target_west:
			valid_target = not east_wall_up
		if not is_target_east and is_target_west:
			valid_target = not west_wall_up
	
	return valid_target
