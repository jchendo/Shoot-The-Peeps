extends Area2D

@export var speed = 300
var direction = 0
var 
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func fire(_target):
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## idk how to go about this one
	var velocity = Vector2.ZERO
	if Input.is_action_just_pressed("shoot"):
		velocity.x = speed
	
		position += velocity * delta
