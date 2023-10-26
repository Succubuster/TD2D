extends Sprite2D

var running = false
var target
signal onTargetReached

# This is a quick and dirty implementation; might need to be refactored
func _process(delta):
	if running:
		if !target:
			animationEnd()
		else:
			global_position = lerp(global_position, target.global_position, 0.05)
			if global_position.distance_to(target.global_position) < 10:
				animationEnd()

func animationEnd():
	hide()
	target = null
	running = false
	onTargetReached.emit()

func setTarget(start, end):
	global_position = start.global_position
	target = end
	running = true
	show()
