extends Area2D

@export var attackDistance: float = 75.0
@export var attackCooldown: float = 2 # in seconds
var canAttack: bool = true

var NON_ENEMY_NAMES = ["Player", "TileMap"]

#signal onAttack

func _ready():
	$AttackRange.shape.radius = attackDistance
	$AttackFrequency.wait_time = attackCooldown
	$AttackFrequency.timeout.connect(func (): 
		canAttack = true
		dealDamage()
	)
	%AttackLoadingIcon.draw.connect(func ():
		var center = Vector2(9, 20)
		var radius = 4
		var startAngle = deg_to_rad(270)
		var endAngle = deg_to_rad(270 - 360 * (%AttackFrequency.time_left / %AttackFrequency.wait_time))
		var pointCount = 32
		%AttackLoadingIcon.draw_arc(center, radius, startAngle, startAngle + TAU, pointCount, Color.SEA_GREEN, 2 * radius)
		%AttackLoadingIcon.draw_arc(center, radius, startAngle, endAngle, pointCount, Color.ORANGE_RED, 2 * radius)
	)
	$AttackFrequency.start()
#	WHY DOESNT BELOW WORK
#	connect("body_entered", func (): print("body entered"))

func _process(delta):
	if !canAttack:
		%AttackLoadingIcon.queue_redraw()
		
func dealDamage():
	if !canAttack: 
		return
	var nearestEnemyDistance = attackDistance
	var nearestEnemy
	for body in get_overlapping_bodies():
		var bodyDistance = global_position.distance_to(body.position)
		if !NON_ENEMY_NAMES.has(body.name) && bodyDistance <= nearestEnemyDistance:
			nearestEnemyDistance = bodyDistance
			nearestEnemy = body
	if !nearestEnemy:
		return
	# Swap below for damage dealing code or signal emit
	nearestEnemy.queue_free()
	# Remove below when xp drops are added
	%Player.changeXP(1) 
	canAttack = false
	$AttackFrequency.start()

func _on_body_entered(body):
	dealDamage()

func changeFrequency(change: float):
	attackCooldown += change
	$AttackFrequency.wait_time = attackCooldown
