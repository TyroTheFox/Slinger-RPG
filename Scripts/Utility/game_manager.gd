extends Node
class_name G_Game_Manager

var current_encounter: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up_developer_console_commands()
	testing_demo()
	set_current_encounter_data()

func testing_demo():
	PlayerManager.create_player_data("Test")

func set_up_developer_console_commands():
	CrabbyConsole.add_custom_command.call_deferred(
		"add_room_card_to_player_inventory", 
		func(room_card_name, room_colour): PlayerManager.player_data.add_room_shape_card(room_card_name, GlobalVariables.room_colours.get(room_colour))
	)

	CrabbyConsole.add_custom_command.call_deferred(
		"add_door_card_to_player_inventory", 
		func(room_card_name): PlayerManager.player_data.add_room_context_card(room_card_name)
	)

func set_current_encounter_data(npcs: Array[String] = [], reward_room_card_ids: Array[Dictionary] = [], reward_door_card_ids: Array[String] = []):
	current_encounter = {
		"player_character": PlayerManager.current_player_character,
		"npc_characters": npcs,
		"rewards": {
			"room_cards": reward_room_card_ids,
			"door_cards": reward_door_card_ids
		}
	}

func grant_player_encounter_reward():
	var rewards_data: Dictionary = current_encounter.rewards
	var rewards_data_keys = rewards_data.keys()

	for reward_key in rewards_data_keys:
		match (reward_key):
			"room_cards":
				var room_cards_data = rewards_data[reward_key]

				for room_card_data in room_cards_data:
					PlayerManager.player_data.add_room_shape_card(room_card_data.name, room_card_data.room_colour)
			"door_cards":
				var door_cards_data = rewards_data[reward_key]

				for door_card in door_cards_data:
					PlayerManager.player_data.add_room_context_card(door_card)