extends Node
class_name C_NPC_Character

signal dead

@onready var hp_component: C_HP_NPC = $C_HP
@export var enemy_name = "Test"
@onready var enemy_stats: GUI_Enemy_Stat_Box = $enemy_stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_stats.set_enemy_name(enemy_name)
	enemy_stats.set_up(hp_component.hp, hp_component.max_hp)

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
	dead.emit()
	print("NPC DEAD!")
