extends Node
class_name G_Game_Manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_up_developer_console_commands()
	testing_demo()

func testing_demo():
	PlayerManager.create_player_data("Test")

func set_up_developer_console_commands():
	CrabbyConsole.add_custom_command.call_deferred(
		"add_room_card_to_player_inventory", 
		func(room_card_name, room_colour): PlayerManager.player_data.add_room_card(room_card_name, GlobalVariables.room_colours.get(room_colour))
	)
