extends Node
class_name C_Weapon_Attack

@onready var weapon_battery_component: C_Weapon_Battery = $"../C_Weapon_Battery"

var attack_power:int = 1

var current_attack_charge: float = 0
var attack_charge_rate: float = 2.5
var attack_charge_maximum: float = 1

var attack_button_held: bool = false
var charging: bool = false

var max_attack_charges: int = 5
var attack_charges: int = 0

var energy_drain_rate = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if button held
	if attack_button_held:
		charging = true
	else:
		charging = false
	
	# If maximum charges hit, stop charging
	if attack_charges >= max_attack_charges:
		attack_charges = max_attack_charges
		charging = false
		
	# If allowed to charge, keep charging
	if charging:
		if weapon_battery_component:
			weapon_battery_component.recharge = false
			if weapon_battery_component.spend_energy(energy_drain_rate, delta):
				current_attack_charge += attack_charge_rate * delta
				print("Attack Charge: ", current_attack_charge)
	
	# If button held and maximum charge hit, increase charges count
	if current_attack_charge >= attack_charge_maximum:
		attack_charges += 1
		current_attack_charge = 0
		print("Charges: ", attack_charges)
	
	# If button released with any amount of attack charge remaining
	if not attack_button_held:
		if (attack_charges > 0 or current_attack_charge > 0):
			deal_damage(attack_power * (1 + attack_charges))
		
		if weapon_battery_component:
			weapon_battery_component.recharge = true
		current_attack_charge = 0
		attack_charges = 0

func deal_damage(damage: int):
	print("ZAP: ", damage)
