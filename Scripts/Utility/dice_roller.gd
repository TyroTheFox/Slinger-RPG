extends Node
class_name Dice_Roller

@onready var random_gen: RandomNumberGenerator = RandomNumberGenerator.new()

## Hard-Coded Die Size Values to use for consistency
enum game_die {D1 = 1, D4 = 4, D6 = 6, D8 = 8, D10 = 10, D12 = 12, D16 = 16, D20 = 20, D100 = 100}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Grab current date and time as a string to use as a seed for the Random Number Gen
	seed(Time.get_date_string_from_system(true).hash())

## Roll dice
func roll(die: game_die, die_count: int = 1, modifier: int = 0) -> int:
	return roll_dice_result(die, die_count, modifier)

## Roll dice, keep highest result
func roll_keep_highest(die: game_die, die_count: int = 1, modifier: int = 0) -> int:
	return roll_dice_keep_highest(die, die_count, modifier)

## Roll dice, keep lowest result
func roll_keep_lowest(die: game_die, die_count: int = 1, modifier: int = 0) -> int:
	return roll_dice_keep_lowest(die, die_count, modifier)

## Roll dice, return if above given threshold
func roll_above_threshold(die: game_die, threshold: int, die_count: int = 1, modifier: int = 0, inclusive: bool = true) -> bool:
	return roll_dice_above_theshold(threshold, die, die_count, modifier, inclusive)

## Roll dice, return if above given threshold
func roll_below_threshold(die: game_die, threshold: int, die_count: int = 1, modifier: int = 0, inclusive: bool = true) -> bool:
	return roll_dice_below_theshold(threshold, die, die_count, modifier, inclusive)

## Rolls a single die. Defaults to d6
func roll_die(side_count: int = 6) -> int:
	return randi_range(1, side_count)

## Rolls a number of dice. Defaults to 1d6
func roll_dice(side_count: int = 1, die_count: int = 6) -> Array[int]:
	var results: Array[int] = []

	for i in die_count:
		results.push_back(roll_die(side_count))

	return results

## Rolls a number of dice, sums the results and adds a modifier. Defaults to 1d6+0.
func roll_dice_result(side_count: int = 1, die_count: int = 6, modifier_value: int = 0) -> int:
	var results = roll_dice(side_count, die_count)

	var results_total = results.reduce(func(accum: int, result: int): return accum + result, modifier_value)

	return results_total

## Rolls a number of dice, adding a modifier to each result
func roll_dice_add_modifier_to_each_result(side_count: int = 1, die_count: int = 6, modifier_value: int = 0) -> Array[int]:
	var results = roll_dice(side_count, die_count)

	results = results.map(func(result: int): return result + modifier_value)

	return results

## Rolls a number of dice, keeps only the highest result
func roll_dice_keep_highest(side_count: int = 1, die_count: int = 6, modifier_value: int = 0) -> int:
	var results = roll_dice_add_modifier_to_each_result(side_count, die_count, modifier_value)

	var highest_result = 0

	for result in results:
		if result > highest_result:
			highest_result = result
	
	return highest_result

## Rolls a number of dice, keeps only the lowest result
func roll_dice_keep_lowest(side_count: int = 1, die_count: int = 6, modifier_value: int = 0) -> int:
	var results = roll_dice_add_modifier_to_each_result(side_count, die_count, modifier_value)

	var lowest_result = 0

	for result in results:
		if result < lowest_result:
			lowest_result = result
	
	return lowest_result

func roll_dice_above_theshold(threshold: int, side_count: int = 1, die_count: int = 6, modifier_value: int = 0, inclusive: bool = true) -> bool:
	var results = roll_dice_add_modifier_to_each_result(side_count, die_count, modifier_value)

	var is_above_threshold = false

	if inclusive:
		is_above_threshold = results.any(func(result: int): return result >= threshold)
	else:
		is_above_threshold = results.any(func(result: int): return result > threshold)

	return is_above_threshold

func roll_dice_below_theshold(threshold: int, side_count: int = 1, die_count: int = 6, modifier_value: int = 0, inclusive: bool = true) -> bool:
	var results = roll_dice_add_modifier_to_each_result(side_count, die_count, modifier_value)

	var is_below_threshold = false

	if inclusive:
		is_below_threshold = results.any(func(result: int): return result <= threshold)
	else:
		is_below_threshold = results.any(func(result: int): return result < threshold)

	return is_below_threshold