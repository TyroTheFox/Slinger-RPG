extends Node
class_name C_Player_Avatar_Controller

@onready var map_manager: Map_Manager = %map_manager
@onready var avatar_spawner: C_Avatar_Spawner = $"../c_avatar_spawner"

var avatar_instance: C_Player_Map_Avatar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_manager.load_finished.connect(_on_map_load_complete)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_map_load_complete(map_instance: C_Exploration_Map):
	avatar_spawner.spacing_x = map_instance.spacing_x
	avatar_spawner.spacing_z = map_instance.spacing_z
	avatar_spawner.full_grid_width = map_instance.full_grid_width
	avatar_spawner.full_grid_height = map_instance.full_grid_height

	avatar_instance = avatar_spawner.spawn_player_avatar(map_instance.avatar_space, map_instance.map_data_resource.avatar_spawn_position)

func move_avatar(move_vector: Vector2i):
	if avatar_instance:
		avatar_instance.move_by(move_vector)