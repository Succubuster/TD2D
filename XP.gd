extends StaticBody2D

var amount: int
var odds: int = 10

func fromEnemy(enemy):
	global_position = enemy.global_position
	# Example of different xp
	if (randi() % odds) + 1 == odds:
		amount = 25
		$High.show()
		$Low.hide()
	else:
		amount = 1
	return self

func hit(player):
	player.changeXP(amount)
	queue_free()
