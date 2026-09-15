extends Control
class_name GUI_Energy

@onready var batteries: Control = $batteries

var battery_bars: Array[ProgressBar]

func set_up(battery_count: int, battery_capacity: float):
	for node in batteries.get_children():
		(node as ProgressBar).visible = false
		battery_bars.push_back(node)
	
	for i in battery_count:
		var battery_bar = (battery_bars[i] as ProgressBar)
		
		battery_bar.visible = true
		battery_bar.value = battery_capacity
		battery_bar.max_value = battery_capacity

func update_energy_total(current_battery: int, current_value: float):
	print("CURRENT_BATTERY: ", current_battery)
	if current_battery > battery_bars.size():
		return
	
	var battery_bar = (battery_bars[current_battery] as ProgressBar)
	
	battery_bar.value = current_value
