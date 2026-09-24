extends Node
class_name C_Weapon_Defend

signal start_defend
signal end_defend

@onready var weapon_battery_component: C_Weapon_Battery = $"../C_Weapon_Battery"

@export var energy_drain_rate = 3      

@export var evade_value = 10

# Amount of energy spent just shooting the weapon
@export var base_attack_energy_cost = 0

var defend_button_held: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_defend.connect(start_defending)
	end_defend.connect(stop_defending)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if button held
	if defend_button_held:
		if weapon_battery_component:
			weapon_battery_component.end_recharge()
			if weapon_battery_component.spend_energy(base_attack_energy_cost, energy_drain_rate, delta):
				start_defending()
			else:
				stop_defending()
	else:
		stop_defending()                   

func start_defending():
	defend_button_held = true
	print("Defending!")

func stop_defending():
	defend_button_held = false
