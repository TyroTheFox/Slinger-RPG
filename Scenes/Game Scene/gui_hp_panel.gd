extends Panel
class_name GUI_HP_Panel

@onready var current_hp_label: Label = $current_hp
@onready var max_hp_label: Label = $max_hp

func set_up(current_hp: int, max_hp: int):
	current_hp_label.text = str(current_hp)
	max_hp_label.text = str(max_hp)

func update_hp(current_hp: int):
	current_hp_label.text = str(current_hp)
