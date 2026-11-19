extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy(character_space: Node3D, player_spawn_point: Vector3, enemy_spawn_point: Vector3) -> C_NPC_Character:
	var current_npc_characters = GameManager.current_encounter.npc_characters
	
	if current_npc_characters.size() == 0:
		return
	
	var npc_character_scene = GlobalVariables.npc_battle_scene_characters.get(current_npc_characters[0])

	var enemy: C_NPC_Character = npc_character_scene.instantiate()
	character_space.add_child(enemy)
	enemy.look_at_from_position(enemy_spawn_point, player_spawn_point)
	
	return enemy
