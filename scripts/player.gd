extends CharacterBody2D

@export var speed = 300.0
@export var health = 60

var screen_size
signal player_hit
signal shoot

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta) -> void:
	
	var velocity = Vector2.ZERO
	# horizontal movement
	if Input.is_action_pressed("move_left"):
		velocity.x  -= 1
		$Player_Animation.flip_h = true
		$Bow_Animation.flip_h = true
	elif Input.is_action_pressed("move_right"):
		$Player_Animation.flip_h = false
		$Bow_Animation.flip_h = false
		velocity.x += 1
	
	# vertical movement
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$Player_Animation.play("player_move")
	else:
		$Player_Animation.play("idle")
	
	if Input.is_action_pressed("shoot"):
		## handle other shoot functions
		$Bow_Animation.play("shoot")
		shoot.emit()
		
	else:
		$Bow_Animation.play("idle")
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	#move_and_slide()

	
