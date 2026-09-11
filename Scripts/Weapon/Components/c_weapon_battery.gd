extends Node
class_name C_Weapon_Battery

var recharge: bool = false

var battery_capacity: int = 5
var battery_count: int = 3

#var current_battery_capacity: float = battery_capacity
var current_battery_count: float = battery_count

var full_battery_capacity: int = battery_capacity * battery_count
var current_full_battery_capacity: float = full_battery_capacity

var recharge_rate: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if recharge and current_full_battery_capacity < full_battery_capacity:
		recharge_battery(delta)

func spend_energy(rate: float, delta: float) -> bool:	
	var drain_amount = rate * delta
	
	var transaction_successful = check_energy_spend(drain_amount)
	
	if transaction_successful:
		current_full_battery_capacity -= drain_amount;
		
		current_battery_count = floor(current_full_battery_capacity / battery_count)
		
		print("Spending: ", current_full_battery_capacity / battery_count, " / ", current_battery_count)
	
	return transaction_successful

func check_energy_spend(drain_amount) -> bool:
	return current_full_battery_capacity >= drain_amount

func recharge_battery(delta: float):
	current_full_battery_capacity += recharge_rate;
	
	if current_full_battery_capacity > full_battery_capacity:
		current_full_battery_capacity = full_battery_capacity
	
	current_battery_count = floor(current_full_battery_capacity / battery_count)
	
	print("Recharging: ", current_full_battery_capacity / battery_count, " / ", current_battery_count)
