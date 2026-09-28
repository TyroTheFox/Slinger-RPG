extends Node
class_name Global_Variables

enum damage_types {PHYSICAL, FIRE, ICE, ELECTRICITY}
enum room_colours {NULL = 0, RED = 1, BLUE = 2, GREEN = 3}

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
