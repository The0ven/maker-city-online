class_name Action

extends Object

var dice = 4
var rng = RandomNumberGenerator.new()
var name = "Action"

func roll_dice() -> int:
	return rng.randi_range(1, self.dice)

func do_action():
	var roll = self.roll_dice()
	print("Ran base Action, roll d4. Got: " + str(roll))
