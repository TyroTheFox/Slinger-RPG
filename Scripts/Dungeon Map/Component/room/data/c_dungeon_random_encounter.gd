extends Node
class_name C_Dungeon_Random_Encounter

var dungeon_map_component: C_Dungeon_Map = null

@export var starting_die: DiceRoller.game_die = DiceRoller.game_die.D12
@export var maximum_die: DiceRoller.game_die = DiceRoller.game_die.D12
@export var minimum_die: DiceRoller.game_die = DiceRoller.game_die.D1

@export var success_threshold: int = 4
@export var critical_failure_threshold: int = 1
@export var rolls_per_encounter_check: int = 1

var success_threshold_modifier: int = 0
var critical_failure_threshold_modifier: int = 0
var rolls_per_encounter_check_modifier: int = 0

var current_success_threshold: int = 0
var current_critical_failure_threshold: int = 0
var current_rolls_per_encounter_check: int = 0

var current_encounter_die: DiceRoller.game_die = starting_die

var npcs_per_encounter: int = 1

enum die_check_result { CRIT_SUCCESS, SUCCESS, FAILURE, CRIT_FAILURE}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CrabbyConsole.add_custom_command("roll_dice", func(): return DiceRoller.roll(DiceRoller.game_die.D6))
	CrabbyConsole.add_custom_command("roll_for_encounter", func(): return roll_for_encounter())

	update_encounter_values()

func process_room_context_data(room_context_data: Dictionary):
	if room_context_data.is_empty():
		return
	var room_context_data_keys = room_context_data.keys()

	for key in room_context_data_keys:
		var value = room_context_data.get(key)
		match(key):
			"roll_per_encounter":
				if rolls_per_encounter_check_modifier != value:
					set_rolls_per_encounter_check_modifier(value)
			"success_threshold":
				if success_threshold_modifier != value:
					set_success_theshold_modifier(value)
			"critical_failure_threshold":
				if critical_failure_threshold_modifier != value:
					set_critical_failure_modifier(value)

func update_encounter_values():
	current_success_threshold = success_threshold + success_threshold_modifier
	current_critical_failure_threshold = critical_failure_threshold + critical_failure_threshold_modifier
	current_rolls_per_encounter_check = rolls_per_encounter_check + rolls_per_encounter_check_modifier

func set_success_theshold_modifier(new_value: int):
	success_threshold_modifier = new_value
	update_encounter_values()

func set_critical_failure_modifier(new_value: int):
	critical_failure_threshold_modifier = new_value
	update_encounter_values()

func set_rolls_per_encounter_check_modifier(new_value: int):
	rolls_per_encounter_check_modifier = new_value
	update_encounter_values()

func start_encounter():
	GameManager.set_current_encounter_data(pick_npcs_to_fight())
	get_tree().call_group("Exploration_Scene", "start_battle_encounter")

func pick_npcs_to_fight() -> Array[String]:
	var return_list: Array[String] = []

	for i in npcs_per_encounter:
		var npc_character_keys = GlobalVariables.npc_battle_scene_characters.keys()
		var result = DiceRoller.roll(npc_character_keys.size()) - 1
		var npc_character_key = npc_character_keys[result]

		return_list.push_back(npc_character_key)
	
	return return_list

func roll_for_encounter():
	print("// // NEW ROLL //")

	for i in current_rolls_per_encounter_check:
		print("// Roll #" + str(i + 1))
		print("Current Encounter Die: " + str(current_encounter_die))
		# Time has ran out, encounter happens.
		if current_encounter_die == DiceRoller.game_die.D1:
			start_encounter()
			return

		var encounter_check_result: die_check_result = make_encounter_check()

		match (encounter_check_result):
			die_check_result.CRIT_SUCCESS:
				print("!CRIT SUCCESS! - STEP UP")
			die_check_result.SUCCESS:
				print("SUCCESS - No Change")
			die_check_result.FAILURE:
				print("FAILURE - STEP DOWN")
			die_check_result.CRIT_FAILURE:
				print("!CRIT FAIL! - STEP DOWN x2")

func make_encounter_check() -> die_check_result:
	var result = roll_encounter_die()
	print("RESULT: " + str(result))

	if result >= current_encounter_die:
		change_encounter_die_step(1)
		return die_check_result.CRIT_SUCCESS
	
	if result >= current_success_threshold:
		return die_check_result.SUCCESS
	
	if result < current_success_threshold:
		if result <= current_critical_failure_threshold:
			change_encounter_die_step(-2)
			return die_check_result.CRIT_FAILURE
		else:
			change_encounter_die_step(-1)
			return die_check_result.FAILURE
	
	return die_check_result.FAILURE

func roll_encounter_die() -> int:
	return DiceRoller.roll(current_encounter_die)

func reset_encounter_die():
	current_encounter_die = maximum_die

func change_encounter_die_step(step_change: int):
	var current_die_key = DiceRoller.game_die.find_key(current_encounter_die)
	var game_dice_key_list = DiceRoller.game_die.keys()
	var current_die_key_index = game_dice_key_list.find(current_die_key)

	if current_die_key_index != -1:
		var new_current_die_key_index = clampi(current_die_key_index + step_change, 0, (game_dice_key_list.size() - 1))

		current_encounter_die = DiceRoller.game_die.get(game_dice_key_list[new_current_die_key_index])

# func step_up_encounter_die(steps: int = 1):
# 	var current_die_key = DiceRoller.game_die.find_key(current_encounter_die)
# 	var game_dice_key_list = DiceRoller.game_die.keys()
# 	var current_die_key_index = game_dice_key_list.find(current_die_key)

# 	if current_die_key_index != -1:
# 		var new_current_die_key_index = current_die_key_index + steps

# 		if new_current_die_key_index > game_dice_key_list.size():
# 			new_current_die_key_index = game_dice_key_list.size()

# 		current_encounter_die = DiceRoller.game_die.get(game_dice_key_list[new_current_die_key_index])

# func step_down_encounter_die(steps: int = 1):
# 	var current_die_key = DiceRoller.game_die.find_key(current_encounter_die)
# 	var game_dice_key_list = DiceRoller.game_die.keys()
# 	var current_die_key_index = game_dice_key_list.find(current_die_key)

# 	if current_die_key_index != -1:
# 		var new_current_die_key_index = current_die_key_index - steps

# 		if new_current_die_key_index < 0:
# 			new_current_die_key_index = 0

# 		current_encounter_die = DiceRoller.game_die.get(game_dice_key_list[new_current_die_key_index])