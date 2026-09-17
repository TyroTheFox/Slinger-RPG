extends Control
class_name GUI_Enemy_Stats

@onready var hp_bar: ProgressBar = $hp
@onready var enemy_name_label: Label = $enemy_name

func set_up(current_hp: int, max_hp: int):
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

func update_hp(current_hp: int):
	hp_bar.value = current_hp

func set_enemy_name(enemy_name: String):
	enemy_name_label.text = enemy_name
