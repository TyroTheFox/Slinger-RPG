extends Control
class_name GUI_Charge

@onready var weapon_charge_bar: ProgressBar = $weapon_charge
@onready var max_charges_label: Label = $max_charges
@onready var current_charges_label: Label = $current_charges

func set_up(max_weapon_charge: float, max_charges: int):
	weapon_charge_bar.max_value = max_weapon_charge
	weapon_charge_bar.value = 0
	
	max_charges_label.text = str(max_charges)
	current_charges_label.text = "0"

func set_weapon_charge_bar_value(current_weapon_charge: float):
	weapon_charge_bar.value = current_weapon_charge

func set_current_charge_value(current_charges: int):
	current_charges_label.text = str(current_charges)
