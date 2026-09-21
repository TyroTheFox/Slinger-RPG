extends NPC_Action
class_name NPC_A_Basic_Attack

@export var attack_power: int = 1

func execute(_delta: float) -> void:
	get_tree().call_group("NPC_Component", "on_deal_damage", attack_power)
