extends Node
class_name C_NPC_Character

@onready var hp_component: C_HP = $C_HP
@export var enemy_name = "Test"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().call_group("Battle_Scene_GUI", "update_enemy_name", enemy_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_deal_damage(damage_dealt: float):
	get_tree().call_group("Player_Character", "on_take_damage", damage_dealt)
	print("NPC DEAL DAMAGE: ", damage_dealt)

func on_take_damage(damage_taken: float):
	hp_component.take_damage(damage_taken)
	print("NPC TAKE DAMAGE: ", damage_taken)

func on_dead():
	print("NPC DEAD!")
