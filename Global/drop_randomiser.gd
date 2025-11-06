extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var miss_buffer: float = 0.0

## Randomly returns true based on "On in X", where X is the first parameter.
## If it returns false, miss_contribution is added to the miss_buffer, and when
## miss_contribution hits 1.0, it resets, and a gaurunteed true will be returned
func random_chance(one_in: int, miss_contribution: float) -> bool:
	assert(one_in >= 1, "Cannot Randomised a value of 0 or less!")
	var success: bool = rng.randi_range(0, one_in - 1) == 0
	if miss_buffer < 1.0 and not success:
		miss_buffer += miss_contribution
		return false
	miss_buffer = 0.0
	return true
