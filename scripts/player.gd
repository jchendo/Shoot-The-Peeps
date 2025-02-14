extends CharacterBody2D

@export var speed = 350.0
@export var health = 12

var screen_size
signal player_hit
signal shoot

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	$Camera2D.limit_right = screen_size.x
	$Camera2D.limit_bottom = screen_size.y + 200
	$Camera2D.limit_top = 50
	
func _process(delta) -> void:
	# horizontal movement
	velocity = Vector2.ZERO
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
	
	if Input.is_action_just_pressed("shoot"):
		shoot.emit()
		
	#position += velocity * delta
	position = position.clamp(Vector2(0, -300), screen_size)
	move_and_slide()

func _on_shoot_animation_finished() -> void:
	$Bow_Animation.play("idle")
