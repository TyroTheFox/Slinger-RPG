extends Node
class_name Battle_Scene_Logic

var player_scene = preload("res://Scenes/Character/player_character.tscn")
var enemy_scene = preload("res://Scenes/Character/enemy_character.tscn")

var player_spawn_points: Array[Node3D]
var enemy_spawn_points: Array[Node3D]
var unused_player_spawn_points: Array[Node3D]
var unused_enemy_spawn_points: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_spawn_node = $player_spawn_points
	var enemy_spawn_node = $enemy_spawn_points
	
	for node in player_spawn_node.get_children():
		player_spawn_points.push_back(node)
	
	for node in enemy_spawn_node.get_children():
		enemy_spawn_points.push_back(node)
	
	unused_player_spawn_points = player_spawn_points.duplicate()
	unused_enemy_spawn_points = enemy_spawn_points.duplicate()
	
	var rand_player_spawn_point = unused_player_spawn_points[randi() % unused_player_spawn_points.size()]
	var rand_enemy_spawn_point = unused_enemy_spawn_points[randi() % unused_enemy_spawn_points.size()]
	
	spawn_player(rand_player_spawn_point.position, rand_enemy_spawn_point.position)
	spawn_enemy(rand_player_spawn_point.position, rand_enemy_spawn_point.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_player(rand_player_spawn_point: Vector3, rand_enemy_spawn_point: Vector3):
	var player = player_scene.instantiate()
	$character_space.add_child(player)
	player.look_at_from_position(rand_player_spawn_point, rand_enemy_spawn_point)

func spawn_enemy(rand_player_spawn_point: Vector3, rand_enemy_spawn_point: Vector3):
	var enemy = enemy_scene.instantiate()
	$character_space.add_child(enemy)
	enemy.look_at_from_position(rand_enemy_spawn_point, rand_player_spawn_point)
