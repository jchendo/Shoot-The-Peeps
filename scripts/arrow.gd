extends Area2D

@export var speed = 300
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## idk how to go about this one
	var velocity = Vector2.ZERO
	if Input.is_action_just_pressed("shoot"):
		velocity.x = speed
	
		position += velocity * delta
