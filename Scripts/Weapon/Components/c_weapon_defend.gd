extends Node
class_name C_Weapon_Defend

@onready var weapon_battery_component: C_Weapon_Battery = $"../C_Weapon_Battery"

var energy_drain_rate = 3      

var evade_value = 10

var defend_button_held: bool = false
var defending: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if button held
	if defend_button_held:
		if weapon_battery_component:
			weapon_battery_component.recharge = false
			if weapon_battery_component.spend_energy(energy_drain_rate, delta):
				start_defending()
			else:
				stop_defending()
	else:
		stop_defending()
		
		if weapon_battery_component:
			weapon_battery_component.recharge = true                        

func start_defending():
	defending = true
	print("Defending!")

func stop_defending():
	defending = false
