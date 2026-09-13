extends Node
class_name C_NPC_Character

@onready var hp_component: C_HP = $"../C_HP"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_deal_damage(damage_dealt: float):
	get_tree().call_group("NPC_Character", "on_deal_damage", damage_dealt)
	print("DEAL DAMAGE: ", damage_dealt)

func on_take_damage(damage_taken: float):
	hp_component.take_damage(damage_taken)
	print("TAKE DAMAGE: ", damage_taken)

func on_dead():
	print("DEAD!")
