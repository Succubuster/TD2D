extends CharacterBody2D

@export var moveSpeed: float = 100.0
var level: int = 1

func _physics_process(delta):
	getInput()
	move_and_slide()

func getInput():
	var inputVec = Input.get_vector(
		'move_left',
		'move_right',
		'move_up',
		'move_down'
	)
	if inputVec:
		velocity = inputVec * moveSpeed
	else:
		velocity = Vector2.ZERO

func changeHealth(change: float):
	%HealthBar.value += change
#	Game over -> currently reset to start
	if !%HealthBar.value:
		get_tree().reload_current_scene()

func changeXP(change: int):
	%XPBar.value += change
	if %XPBar.value >= %XPBar.max_value:
		levelUp()
	$"%XPBar/Count".text = "%s / %s" % [%XPBar.value, %XPBar.max_value]

func levelUp():
#	full heal
	%HealthBar.value = %HealthBar.max_value
#	update xp bar
	%XPBar.min_value = %XPBar.max_value
	%XPBar.max_value *= 2
	level += 1
	$"%XPBar/Level".text = "LVL: %s" % level
#	level result
	$AttackRangeAnchor.changeFrequency(-0.1)
