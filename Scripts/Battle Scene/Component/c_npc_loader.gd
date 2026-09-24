extends Node

var enemy_scene = preload("res://Scenes/Character/enemy_character.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy(character_space: Node3D, player_spawn_point: Vector3, enemy_spawn_point: Vector3) -> C_NPC_Character:
	var enemy: C_NPC_Character = enemy_scene.instantiate()
	character_space.add_child(enemy)
	enemy.look_at_from_position(enemy_spawn_point, player_spawn_point)
	
	return enemy
