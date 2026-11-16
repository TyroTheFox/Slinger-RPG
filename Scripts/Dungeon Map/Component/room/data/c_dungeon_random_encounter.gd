extends Node
class_name C_Dungeon_Random_Encounter

@export var starting_die: DiceRoller.game_die = DiceRoller.game_die.D12
@export var maximum_die: DiceRoller.game_die = DiceRoller.game_die.D12
@export var minimum_die: DiceRoller.game_die = DiceRoller.game_die.D2

@export var success_threshold: int = 4
@export var critical_failure_threshold: int = 1

var current_encounter_die: DiceRoller.game_die = starting_die

enum die_check_result { CRIT_SUCCESS, SUCCESS, FAILURE, CRIT_FAILURE}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CrabbyConsole.add_custom_command("roll_dice", func(): return DiceRoller.roll(DiceRoller.game_die.D6))
	CrabbyConsole.add_custom_command("roll_for_encounter", func(): return roll_for_encounter())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func roll_for_encounter():
	print("Current Encounter Die: " + str(current_encounter_die))
	var encounter_check_result: die_check_result = make_encounter_check()

	match (encounter_check_result):
		die_check_result.CRIT_SUCCESS:
			print("!CRIT SUCCESS! - No Encounter")
		die_check_result.SUCCESS:
			print("SUCCESS - No Encounter")
		die_check_result.FAILURE:
			print("FAILURE - Encounter")
		die_check_result.CRIT_FAILURE:
			print("!CRIT FAIL! - Encounter")

func make_encounter_check() -> die_check_result:
	var result = roll_encounter_die()
	print("RESULT: " + str(result))

	if result >= current_encounter_die:
		step_up_encounter_die()
		return die_check_result.CRIT_SUCCESS
	
	if result >= success_threshold:
		return die_check_result.SUCCESS
	
	if result < success_threshold:
		if result <= critical_failure_threshold:
			step_down_encounter_die(2)
			return die_check_result.CRIT_FAILURE
		else:
			step_down_encounter_die()
			return die_check_result.FAILURE
	
	return die_check_result.FAILURE

func roll_encounter_die() -> int:
	return DiceRoller.roll(current_encounter_die)

func reset_encounter_die():
	current_encounter_die = maximum_die

func step_up_encounter_die(steps: int = 1):
	var current_die_key = DiceRoller.game_die.find_key(current_encounter_die)
	var game_dice_key_list = DiceRoller.game_die.keys()
	var current_die_key_index = game_dice_key_list.find(current_die_key)

	if current_die_key_index != -1:
		var new_current_die_key_index = current_die_key_index + steps

		if new_current_die_key_index > game_dice_key_list.size():
			new_current_die_key_index = game_dice_key_list.size()

		current_encounter_die = DiceRoller.game_die.get(game_dice_key_list[new_current_die_key_index])

func step_down_encounter_die(steps: int = 1):
	var current_die_key = DiceRoller.game_die.find_key(current_encounter_die)
	var game_dice_key_list = DiceRoller.game_die.keys()
	var current_die_key_index = game_dice_key_list.find(current_die_key)

	if current_die_key_index != -1:
		var new_current_die_key_index = current_die_key_index - steps

		if new_current_die_key_index < 0:
			new_current_die_key_index = 0

		current_encounter_die = DiceRoller.game_die.get(game_dice_key_list[new_current_die_key_index])