extends Resource
class_name R_Player_Resource

var player_name: String = ""
var room_shape_card_id_count: int = 0
var room_context_card_id_count: int = 0

# Player Inventory
var room_shape_cards: Array[Dictionary] = []
var room_context_cards: Array[Dictionary] = []

func get_room_shape_id() -> int:
	var new_id = room_shape_card_id_count

	room_shape_card_id_count += 1

	return new_id

func get_room_context_id() -> int:
	var new_id = room_context_card_id_count

	room_context_card_id_count += 1

	return new_id

func add_room_shape_card(room_shape_name: String, room_colour: GlobalVariables.room_colours):
	if GlobalVariables.room_shape_data.has(room_shape_name):
		room_shape_cards.push_back({
			"id": get_room_shape_id(),
			"name": room_shape_name,
			"colour": room_colour
		})

func remove_room_shape_card(unique_id: int):
	var index = room_shape_cards.find_custom(func(entry): return entry.id == unique_id)

	if index >= 0:
		room_shape_cards.remove_at(index)

func get_room_shape_card_by_id(unique_id: int) -> Dictionary:
	var index = room_shape_cards.find_custom(func(entry): return entry.id == unique_id)

	if index >= 0:
		return room_shape_cards.get(index)
	
	return {}

func add_room_context_card(room_context_name: String):
	if GlobalVariables.room_context_data.has(room_context_name):
		room_context_cards.push_back({
			"id": get_room_context_id()
		})

func remove_room_context_card(unique_id: int):
	var index = room_shape_cards.find_custom(func(entry): return entry.id == unique_id)

	if index >= 0:
		room_shape_cards.remove_at(index)

func get_room_context_card_by_id(unique_id: int) -> Dictionary:
	var index = room_shape_cards.find_custom(func(entry): return entry.id == unique_id)

	if index >= 0:
		return room_shape_cards.get(index)
	
	return {}