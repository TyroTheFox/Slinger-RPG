extends Node
class_name Global_Variables

enum damage_types {PHYSICAL, FIRE, ICE, ELECTRICITY}
enum room_colours {NULL = 0, RED = 1, BLUE = 2, GREEN = 3}
enum cardinal_direction {NORTH, SOUTH, EAST, WEST}
enum card_type {NONE, ROOM_SHAPE, ROOM_CONTEXT}

var save_file_path: String = "res://Data/Save_Files/"

var standard_battle_scene: String = "battle_scene"

var scene_list: Dictionary = {
	"loading_screen": "uid://ctgaweu03c52w",
	"main_menu": "uid://d34vae1phmym1",
	"battle_scene": "uid://yxlb8lulst2t",
	"dungeon_map": "uid://b3pleediwacwn",
	"game_over": "uid://cmxvge7nkpy0v"
}

var map_scene_list: Dictionary = {
	"test_map": "uid://by7naxq6i8tsr"
}

var room_colour_values: Dictionary = {
	room_colours.NULL: Color(1.0, 1.0, 1.0, 1.0),
	room_colours.RED: Color(0.586, 0.0, 0.0, 1.0),
	room_colours.BLUE: Color(0.0, 0.0, 0.586, 1.0),
	room_colours.GREEN: Color(0.0, 0.586, 0.0, 1.0)
}

var room_textures: Dictionary = {
	room_colours.NULL: preload("uid://bki71vcdilrqo"),
	room_colours.RED: preload("uid://cu7qmn8yyvhxv"),
	room_colours.BLUE: preload("uid://daybptfswylyw"),
	room_colours.GREEN: preload("uid://byd823dy2xuum")
}

var room_shape_data: Dictionary = {
	"1x1": preload("uid://cw4uymuslvut7"),
	"1x2": preload("uid://bdvsovkwrba5t"),
	"2x2": preload("uid://ne4tcv6h30lw"),
	"2x2+1x1": preload("uid://ch250l88phbyf"),
	"L": preload("uid://3dtnpcp54xmb")
}

var room_context_data: Dictionary = {
	"test": preload("uid://c357jh2y6o4gq")
}

var room_context_effect_data: Dictionary = {
	"test": {
		"roll_per_encounter": 1,
		"success_threshold": 0,
		"critical_failure_threshold": 0
	}
}

var card_data: Dictionary = {
	card_type.ROOM_SHAPE: preload("uid://bx7rqr7nfs1p5"),
	card_type.ROOM_CONTEXT: preload("uid://btefmttiqcxwf")
}

var player_battle_scene_characters = {
	"test": preload("uid://bkyjwgxwfhbgx")
}

var npc_battle_scene_characters = {
	"test": preload("uid://bd3tuqc3m30gr")
}

func get_random_npc_name() -> String:
	return get_random_dictionary_result(npc_battle_scene_characters)

func get_random_room_shape_name() -> String:
	return get_random_dictionary_result(room_shape_data)

func get_random_room_context_name() -> String:
	return get_random_dictionary_result(room_context_effect_data)

func get_random_room_colour() -> room_colours:
	var room_colour_name = get_random_dictionary_result(room_colours, -1, 1)

	return room_colours.get(room_colour_name)

func get_random_dictionary_result(dictionary: Dictionary, size_modifer: int = 0, result_modifier: int = 0) -> Variant:
	var dictionary_keys = dictionary.keys()
	var dictionary_keys_size = dictionary_keys.size()

	if dictionary_keys_size == 1:
		return dictionary_keys[0]

	var result = DiceRoller.roll((dictionary_keys_size - 1) + size_modifer) + result_modifier
	return dictionary_keys[result]