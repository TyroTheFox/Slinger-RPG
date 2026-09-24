extends Node
class_name C_Player_Loader

var player_scene = preload("res://Scenes/Character/player_character.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_player(character_space: Node3D, player_spawn_point: Vector3, enemy_spawn_point: Vector3) -> C_Player_Character:
	var player: C_Player_Character = player_scene.instantiate()
	character_space.add_child(player)
	player.look_at_from_position(player_spawn_point, enemy_spawn_point)
	
	return player
