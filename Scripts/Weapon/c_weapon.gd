extends Node
class_name C_Weapon

signal charge_weapon
signal fire_weapon

signal start_defend
signal end_defend

signal start_recharge
signal end_recharge

var weapon_attack_component: C_Weapon_Attack
var weapon_defend_component: C_Weapon_Defend
var weapon_battery_component: C_Weapon_Battery

var recharge_speed = 1
var capacity = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon_attack_component = $C_Weapon_Attack
	weapon_defend_component = $C_Weapon_Defend
	weapon_battery_component = $C_Weapon_Battery
	
	charge_weapon.connect(on_charge_weapon)
	fire_weapon.connect(on_fire_weapon)
	
	start_defend.connect(on_start_defend)
	end_defend.connect(on_end_defend)
	
	start_recharge.connect(on_start_recharge)
	end_recharge.connect(on_end_rechargee)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_charge_weapon():
	weapon_attack_component.charge_weapon.emit()

func on_fire_weapon():
	weapon_attack_component.fire_weapon.emit()

func on_start_defend():
	weapon_defend_component.start_defend.emit()

func on_end_defend():
	weapon_defend_component.end_defend.emit()

func on_start_recharge():
	weapon_battery_component.start_charge.emit()

func on_end_rechargee():
	weapon_battery_component.stop_charge.emit()
