extends Resource
class_name R_Map_Data

@export var name: String = ""

@export var player_grid_position: Vector2i = Vector2i(0, 0)

# // SQUARES //

var square_list: Array[C_Room_Square] = []
var square_index_count: int = 0

# // ROOMS //

var room_list: Array[Dictionary] = []
var room_index_count: int = 0

# // DOOR //

var door_list: Array[Dictionary] = []
var door_index_count: int = 0

# // EFFECT //

var active_context_list: Array[Dictionary] = []
var active_context_index_count: int = 0

# // RANDOM ENCOUNTER //

var success_threshold_modifier: int = 0
var critical_failure_threshold_modifier: int = 0
var rolls_per_encounter_check_modifier: int = 0

var current_success_threshold: int = 0
var current_critical_failure_threshold: int = 0
var current_rolls_per_encounter_check: int = 0

var current_encounter_die: DiceRoller.game_die = DiceRoller.game_die.D12

var npcs_per_encounter: int = 1