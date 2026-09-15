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
	if current_battery + 1 > battery_bars.size():
		return
	
	for i in (current_battery + 1):
		var battery_bar = (battery_bars[i] as ProgressBar)
		
		if i == current_battery:
			battery_bar.value = current_value
			print("Battery ", i, ": ", current_value)
		else:
			battery_bar.value = battery_bar.max_value
