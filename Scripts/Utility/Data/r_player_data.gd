extends Resource
class_name R_Player_Resource

var player_name: String = ""
var room_card_id_count: int = 0

# Player Inventory
var room_cards: Array[Dictionary] = []

func add_room_card(room_shape_name: String, room_colour: GlobalVariables.room_colours):
	if GlobalVariables.room_shape_data.has(room_shape_name):
		room_cards.push_back({
			"id": room_card_id_count,
			"name": room_shape_name,
			"colour": room_colour
		})

		room_card_id_count += 1

func remove_room_card(unique_id: int):
	var index = room_cards.find_custom(func(entry): return entry.id == unique_id)

	if index >= 0:
		room_cards.remove_at(index)

func get_room_card_by_id(unique_id: int) -> Dictionary:
	var index = room_cards.find_custom(func(entry): return entry.id == unique_id)

	if index >= 0:
		return room_cards.get(index)
	
	return {}