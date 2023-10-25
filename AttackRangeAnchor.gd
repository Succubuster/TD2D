extends Area2D

@export var attackDistance: float = 75.0
@export var attackCooldown: float = 1 # in seconds
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
	$AttackFrequency.start()
#	WHY DOESNT BELOW WORK
#	connect("body_entered", func (): print("body entered"))

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
	canAttack = false
	$AttackFrequency.start()

func _on_body_entered(body):
	dealDamage()
