extends Area2D

@export var attackDistance: float = 100.0
@export var attackCooldown: float = 2 # in seconds
var canAttack: bool = true

#signal onAttack

func _ready():
	$AttackRange.shape.radius = attackDistance
	$AttackFrequency.wait_time = attackCooldown
	$AttackFrequency.timeout.connect(func ():
		canAttack = true
		dealDamage()
	)
	#Maybe move below out to a scene for reusability
	%AttackLoadingIcon.draw.connect(func ():
		var center = Vector2(14, 32)
		var radius = 6
		var startAngle = deg_to_rad(270)
		var endAngle = deg_to_rad(270 - 360 * (%AttackFrequency.time_left / %AttackFrequency.wait_time))
		var pointCount = 32
		%AttackLoadingIcon.draw_arc(center, radius, startAngle, startAngle + TAU, pointCount, Color.SEA_GREEN, 2 * radius)
		%AttackLoadingIcon.draw_arc(center, radius, startAngle, endAngle, pointCount, Color.ORANGE_RED, 2 * radius)
	)
	$AttackFrequency.start()
	dealDamage()
#	WHY DOESNT BELOW WORK
#	connect("body_entered", func (): print("body entered"))

func _process(delta):
	if !canAttack:
		%AttackLoadingIcon.queue_redraw()
	else:
		dealDamage()

func dealDamage():
	if !canAttack:
		return
	var nearestEnemy = getClosestEnemy()
	if !nearestEnemy:
		return
	canAttack = false
	%Crosshair.setTarget(self, nearestEnemy)
	%Crosshair.onTargetReached.connect(damageResult.bind(nearestEnemy))

func getClosestEnemy():
	var nearestEnemyDistance = attackDistance
	var nearestEnemy
	for body in get_overlapping_bodies():
		var bodyDistance = global_position.distance_to(body.position)
		if bodyDistance <= nearestEnemyDistance:
			nearestEnemyDistance = bodyDistance
			nearestEnemy = body
	return nearestEnemy

func damageResult(nearestEnemy):
	if is_instance_valid(nearestEnemy):
		nearestEnemy.death()
	%Crosshair.onTargetReached.disconnect(self.damageResult)
	$AttackFrequency.start()

func changeFrequency(change: float):
	attackCooldown += change
	$AttackFrequency.wait_time = attackCooldown

# below is not triggering consistently
#func _on_body_entered(body):
	#dealDamage()
