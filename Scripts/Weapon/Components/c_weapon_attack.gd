extends Node
class_name C_Weapon_Attack

signal charge_weapon
signal fire_weapon

@onready var weapon_battery_component: C_Weapon_Battery = $"../C_Weapon_Battery"
@onready var projectile_attack_animation_component: C_Projectile_Attack_Animation = $"../C_Projectile_Attack_Animation"

# Base Attack Power
@export var attack_power:int = 1

# Rate at which the Weapon charges a single Attack Charge, which boosts damage (rate per tick)
@export var attack_charge_rate: float = 2.5

# Maximum Number of Stored Charges Allowed before the Weapon Fires
@export var max_attack_charges: int = 5

# How fast the weapon depletes energy from the Battery reserve (rate per tick)
@export var energy_drain_rate = 10

# The maximum amount of progress required to gain one Weapon Charge
@export var charge_progress_threshold: float = 1

# The length of time before the Player can shoot the gun again after firing
@export var attack_cooldown: float = 1

# Amount of energy spent just shooting the weapon
@export var base_attack_energy_cost = 1

# Current progress towards an attack charge
var current_charge_progress: float = 0

var attack_button_held: bool = false

# Current Attack Charges stored
var attack_charges: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	charge_weapon.connect(on_charge_weapon)
	fire_weapon.connect(on_fire_weapon)
	
	get_tree().call_group("Battle_Scene_GUI", "set_up_charge", charge_progress_threshold, max_attack_charges)

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
		current_charge_progress = charge_progress_threshold
		return
		
	# If allowed to charge, keep charging
	if weapon_battery_component:
		weapon_battery_component.end_recharge()
		if weapon_battery_component.spend_energy(base_attack_energy_cost, energy_drain_rate, delta):
			current_charge_progress += attack_charge_rate * delta
			print("Attack Charge: ", current_charge_progress)
	
	# If button held and maximum charge hit, increase charges count
	if current_charge_progress >= charge_progress_threshold:
		attack_charges += 1
		current_charge_progress = 0
		print("Charges: ", attack_charges)
	
	get_tree().call_group("Battle_Scene_GUI", "set_weapon_charge_bar_value", current_charge_progress)
	get_tree().call_group("Battle_Scene_GUI", "set_current_charge_value", attack_charges)

func shoot():
	if (attack_charges > 0 or current_charge_progress > 0) and weapon_battery_component.take_energy(base_attack_energy_cost):
		projectile_attack_animation_component.emit_attack_projectile(attack_charges)
		deal_damage(attack_power * (1 + attack_charges))
	
	current_charge_progress = 0
	attack_charges = 0
	
	get_tree().call_group("Battle_Scene_GUI", "set_current_charge_value", attack_charges)
	get_tree().call_group("Battle_Scene_GUI", "set_weapon_charge_bar_value", current_charge_progress)

func deal_damage(damage: int):
	get_tree().call_group("Player_Component", "on_deal_damage", damage)

func on_charge_weapon():
	attack_button_held = true

func on_fire_weapon():
	attack_button_held = false
