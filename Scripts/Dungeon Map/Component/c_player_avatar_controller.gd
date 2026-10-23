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

func _on_map_load_complete(map_instance: C_Exploration_Map, map_data_component: C_Dungeon_Map):
	avatar_spawner.spacing_x = map_data_component.spacing_x
	avatar_spawner.spacing_z = map_data_component.spacing_z
	avatar_spawner.full_grid_width = map_data_component.full_grid_width
	avatar_spawner.full_grid_height = map_data_component.full_grid_height

	avatar_instance = avatar_spawner.spawn_player_avatar(map_instance.avatar_space, map_data_component.map_data_resource.avatar_spawn_position)

	map_data_component.room_data_updated.connect(_on_room_data_updated)
	map_data_component.room_list_updated.connect(_on_room_list_updated)

	avatar_instance.set_room_grid(map_data_component.room_grid)
	avatar_instance.set_room_list(map_data_component.room_list, map_data_component.square_list)

func _on_room_data_updated(room_grid: Array[Array]):
	avatar_instance.set_room_grid(room_grid)

func _on_room_list_updated(room_list: Array[Dictionary], square_list: Array[C_Room_Square]):
	avatar_instance.set_room_list(room_list, square_list)

func move_avatar(move_vector: Vector2i):
	if avatar_instance:
		avatar_instance.move_by(move_vector)