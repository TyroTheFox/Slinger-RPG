extends Node
class_name C_Avatar_Spawner

var player_scene: PackedScene = preload("res://Scenes/Character/player_map_avatar.tscn")

var spacing_x: float = 1.0
var spacing_z: float = 1.0
var full_grid_width = 0
var full_grid_height = 0

func spawn_player_avatar(avatar_space: Node3D, position: Vector2i) -> C_Player_Map_Avatar:
	var player: C_Player_Map_Avatar = player_scene.instantiate()
	avatar_space.add_child(player)

	player.set_up(spacing_x, spacing_z, full_grid_width, full_grid_height)
	player.set_grid_position(position)

	return player
