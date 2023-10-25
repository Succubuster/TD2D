extends CharacterBody2D

@export var moveSpeed: float = 50.0
@export var damage: float = 1.0

@onready var Player = $"/root/Main/Player"
@onready var NavAgent = $NavigationAgent2D

func _ready():
	var randAngle = randi() % 360
	var radius = 150
	position = Vector2(sin(randAngle), cos(randAngle)) * radius

func _physics_process(delta):
	NavAgent.target_position = Player.position
	if !NavAgent.is_navigation_finished():
		var direction = position.direction_to(NavAgent.get_next_path_position())
		velocity = direction * moveSpeed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	if get_last_slide_collision():
		if get_last_slide_collision().get_collider().name == "Player":
			Player.changeHealth(-damage)
			queue_free()
