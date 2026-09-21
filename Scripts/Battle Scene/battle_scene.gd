extends Node
class_name Battle_Scene

@export var character_space: Node3D
@export var game_over_scene: String
@export var dungeon_map_scene: String

@onready var c_player_loader: C_Player_Loader = $C_Player_Loader
@onready var c_npc_loader: Node = $C_NPC_Loader

@onready var player_spawn_node: Node3D = $player_spawn_points
@onready var enemy_spawn_node = $enemy_spawn_points

var player_spawn_points: Array[Node3D]
var enemy_spawn_points: Array[Node3D]
var unused_player_spawn_points: Array[Node3D]
var unused_enemy_spawn_points: Array[Node3D]

var player: C_Player_Character = null
var enemy: C_NPC_Character = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in player_spawn_node.get_children():
		player_spawn_points.push_back(node)
	
	for node in enemy_spawn_node.get_children():
		enemy_spawn_points.push_back(node)
	
	reset_available_spawn_points()
	
	var rand_player_spawn_point = get_random_player_spawn_point()
	var rand_enemy_spawn_point = get_random_npc_spawn_point()
	
	player = c_player_loader.spawn_player(character_space, rand_player_spawn_point.position, rand_enemy_spawn_point.position)
	enemy = c_npc_loader.spawn_enemy(character_space, rand_player_spawn_point.position, rand_enemy_spawn_point.position)
	
	player.dead.connect(_on_player_dead)
	enemy.dead.connect(_on_npc_dead)

func get_random_player_spawn_point() -> Node3D:
	var random_number = randi() % unused_player_spawn_points.size()
	var rand_player_spawn_point = unused_player_spawn_points.pop_at(random_number)
	
	return rand_player_spawn_point

func get_random_npc_spawn_point() -> Node3D:
	var random_number = randi() % unused_enemy_spawn_points.size()
	var rand_enemy_spawn_point = unused_enemy_spawn_points.pop_at(random_number)
	
	return rand_enemy_spawn_point

func reset_available_spawn_points():
	unused_player_spawn_points = player_spawn_points.duplicate()
	unused_enemy_spawn_points = enemy_spawn_points.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_player_dead():
	SceneManager.load_saved_scene(game_over_scene)

func _on_npc_dead():
	SceneManager.load_saved_scene(dungeon_map_scene)
