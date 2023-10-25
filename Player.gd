extends CharacterBody2D

@export var moveSpeed: float = 100.0
	
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
	$HealthBar.value += change
	
