extends CharacterBody2D

@export var moveSpeed: float = 100.0
var level: int = 1
var maxXPScaling: int = 2
var attackRateScaling: float = -0.3

func _ready() -> void:
	Audio.listenerTarget = self

func _physics_process(delta):
	getInput()
	move_and_slide()
	resolveCollisions()

func resolveCollisions():
	for body in $SoftColliderAnchor.get_overlapping_bodies():
		body.hit(self)

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
	if %HealthBar.value <= %HealthBar.min_value:
		#get_tree().reload_current_scene() # NOTE keeping this here since surely we'll wanna toggle on/off during development
		get_tree().change_scene_to_file('res://MainMenu.tscn')

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
#	doubling will be too aggressive if xp and enemy don't scale
	%XPBar.max_value *= maxXPScaling
	level += 1
	$"%XPBar/Level".text = "LVL: %s" % level
#	level result
	$AttackRangeAnchor.changeFrequency(attackRateScaling)
	if %XPBar.value >= %XPBar.max_value:
		levelUp()
