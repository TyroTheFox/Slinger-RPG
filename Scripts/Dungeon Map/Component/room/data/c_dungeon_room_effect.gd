extends Node
class_name C_Dungeon_Room_Effect

var dungeon_map_component: C_Dungeon_Map = null
var dungeon_room_component: C_Dungeon_Rooms = null

var active_context_list: Array[Dictionary] = []
var active_context_index_count: int = 0

## Either finds the context data entry or returns an empty Dictionary
func get_context_data_by_id(id: int) -> Dictionary:
	var context_data_index = get_contex_data_index_by_id(id)

	if context_data_index != -1:
		return active_context_list[context_data_index]
	else:
		return {}

## Either finds the context data entry or returns an empty Dictionary
func get_context_data_by_room_id(room_id: int) -> Dictionary:
	var context_data_index = get_contex_data_index_by_room_id(room_id)

	if context_data_index != -1:
		return active_context_list[context_data_index]
	else:
		return {}

func get_contex_data_index_by_id(id: int) -> int:
	return active_context_list.find_custom(func(entry: Dictionary): return entry.id == id)

func get_contex_data_index_by_room_id(room_id: int) -> int:
	return active_context_list.find_custom(func(entry: Dictionary): return entry.room_id == room_id)

func create_room_context(room_id: int, context_effect_id: String, door_id: int) -> Dictionary:
	var room_context = {}

	if GlobalVariables.room_context_effect_data.has(context_effect_id):
		room_context = GlobalVariables.room_context_effect_data.get(context_effect_id)

	var new_context_data: Dictionary = {
		"id": active_context_index_count,
		"room_id": room_id,
		"context_effect_id": context_effect_id,
		"door_id": door_id,
		"room_context": room_context
	}
	active_context_index_count += 1

	active_context_list.append(new_context_data)

	return new_context_data

func save_data():
	var base_map_data: Map_Data = dungeon_map_component.map_data_resource

	if !SaveManager.check_for_map_data_entry_by_name(base_map_data.name):
		# Make new entry
		SaveManager.create_new_map_data_entry(base_map_data.name)

	# Update current data
	SaveManager.set_map_effect_data(base_map_data.name, active_context_list, active_context_index_count)