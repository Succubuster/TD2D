extends Node2D

@onready var Enemy = preload("res://enemy.tscn")


func _ready():
	create_tween().set_loops().tween_callback(
		func ():
			var enemy = Enemy.instantiate()
			var randAngle = randi() % 360
			var radius = 150
			enemy.position = Vector2(sin(randAngle), cos(randAngle)) * radius
			add_child(enemy)
	).set_delay(1)
