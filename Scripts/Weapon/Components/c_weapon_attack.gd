extends Node
class_name C_Weapon_Attack

signal charge_weapon
signal fire_weapon

@onready var weapon_battery_component: C_Weapon_Battery = $"../C_Weapon_Battery"

var attack_power:int = 1

var current_attack_charge: float = 0
var attack_charge_rate: float = 2.5
var attack_charge_maximum: float = 1

var attack_button_held: bool = false

var max_attack_charges: int = 5
var attack_charges: int = 0

var energy_drain_rate = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charge_weapon.connect(on_charge_weapon)
	fire_weapon.connect(on_fire_weapon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if button held
	if attack_button_held:
		charge_attack(delta)
	else:
		shoot()

func charge_attack(delta: float):
	# If maximum charges hit, stop charging
	if attack_charges >= max_attack_charges:
		attack_charges = max_attack_charges
		
	# If allowed to charge, keep charging
	if weapon_battery_component:
		weapon_battery_component.end_recharge()
		if weapon_battery_component.spend_energy(energy_drain_rate, delta):
			current_attack_charge += attack_charge_rate * delta
			print("Attack Charge: ", current_attack_charge)
		else:
			return
	
	# If button held and maximum charge hit, increase charges count
	if current_attack_charge >= attack_charge_maximum:
		attack_charges += 1
		current_attack_charge = 0
		print("Charges: ", attack_charges)

func shoot():
	if (attack_charges > 0 or current_attack_charge > 0):
		deal_damage(attack_power * (1 + attack_charges))
	
	current_attack_charge = 0
	attack_charges = 0

func deal_damage(damage: int):
	get_tree().call_group("Player_Component", "on_deal_damage", damage)

func on_charge_weapon():
	attack_button_held = true

func on_fire_weapon():
	attack_button_held = false
