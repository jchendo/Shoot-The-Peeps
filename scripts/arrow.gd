extends Area2D

@export var speed = 300
var direction
var target
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func fire(_target):
	## updates direction to target whenever called
	if is_instance_valid(_target):
		target = _target
		direction = position.angle_to_point(_target.position)
	else: ## if goblin dies before arrows reach (ex. spamming arrows)
		direction = rotation
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2(250,0)
	var arrow_linear_velocity = velocity.rotated(direction)
	fire(target)
	rotation = direction
	position += arrow_linear_velocity * delta

func _on_area_entered(area: Area2D) -> void:
	queue_free()
