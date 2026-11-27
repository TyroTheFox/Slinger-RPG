extends Resource
class_name R_Map_Data

@export var name: String = ""

@export var player_grid_position: Vector2i = Vector2i(0, 0)

@export var room_grid: Array[Array]

@export var full_grid_width = 0
@export var full_grid_height = 0

# // SQUARES //

@export var square_list: Array[int] = []
@export var square_index_count: int = 0

# // ROOMS //

@export var room_list: Array[Dictionary] = []
@export var room_index_count: int = 0

# // DOOR //

@export var door_list: Array[Dictionary] = []
@export var door_index_count: int = 0

# // EFFECT //

@export var active_context_list: Array[Dictionary] = []
@export var active_context_index_count: int = 0

# // RANDOM ENCOUNTER //

@export var success_threshold_modifier: int = 0
@export var critical_failure_threshold_modifier: int = 0
@export var rolls_per_encounter_check_modifier: int = 0

@export var current_success_threshold: int = 0
@export var current_critical_failure_threshold: int = 0
@export var current_rolls_per_encounter_check: int = 0

@export var current_encounter_die: DiceRoller.game_die = DiceRoller.game_die.D12

@export var npcs_per_encounter: int = 1

func process_room_grid(room_grid: Array[Array]):
    for x in room_grid.size():
        room_grid[x].push_back([])
        for y in room_grid[x].size():
            var room_grid_square: C_Room_Square = room_grid[x][y]

            var new_square_entry = {
                "id": room_grid_square.square_id,
                "room_id": room_grid_square.room_id,
                "matching_neighbours": room_grid_square.matching_neighbours,
                "colour": room_grid_square.room_colour,
                "grid_room": room_grid_square.c_grid_room
            }

            room_grid[x][y].push_back(new_square_entry)

func add_room_square_to_room_list(new_square: C_Room_Square):
    square_list.push_back(new_square.square_id)
