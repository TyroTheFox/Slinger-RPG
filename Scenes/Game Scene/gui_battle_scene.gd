extends Control
class_name GUI_Battle_Scene

static var gui_battle_scene: GUI_Battle_Scene = null

@onready var hp_panel: GUI_HP_Panel = $player_stats/hp_panel
@onready var charge: GUI_Charge = $player_stats/weapon/charge
@onready var energy: GUI_Energy = $player_stats/weapon/energy

@onready var enemy_stats: GUI_Enemy_Stats = $enemy_stats

func set_up_hp_player(current_hp: int, max_hp: int):
	hp_panel.set_up(current_hp, max_hp)

func set_up_hp_npc(current_hp: int, max_hp: int):
	enemy_stats.set_up(current_hp, max_hp)

func set_up_charge(max_weapon_charge: float, max_charges: int):
	charge.set_up(max_weapon_charge, max_charges)

func set_up_energy(battery_count: int, battery_capacity: float):
	energy.set_up(battery_count, battery_capacity)

func update_hp_player(current_hp: int):
	hp_panel.update_hp(current_hp)

func update_hp_npc(current_hp: int):
	enemy_stats.update_hp(current_hp)

func update_enemy_name(enemy_name: String):
	enemy_stats.set_enemy_name(enemy_name)

func set_weapon_charge_bar_value(current_weapon_charge: float):
	charge.set_weapon_charge_bar_value(current_weapon_charge)

func set_current_charge_value(current_charges: int):
	charge.set_current_charge_value(current_charges)

func update_energy_total(current_battery: int, current_value: float):
	energy.update_energy_total(current_battery, current_value)
