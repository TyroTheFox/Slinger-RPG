extends NPC_Action
class_name NPC_A_Basic_Attack

@export var attack_power: int = 1
@export var animation_player: AnimationPlayer
@export var attack_animation_name: String = "attack"

func execute(_delta: float) -> void:
	animation_player.play(attack_animation_name)
	await animation_player.animation_finished
	get_tree().call_group("NPC_Component", "on_deal_damage", attack_power)
