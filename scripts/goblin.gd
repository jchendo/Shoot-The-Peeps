extends CharacterBody2D

signal hit_player
signal hit_goblin
signal died
var health = randi_range(10,30)
var direction = 0
var player ## for hunting purposes
var hittable = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("run")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2(randf_range(150.0, 250), 0)
	if health <= 0:
		$AnimatedSprite2D.play("death")
		remove_from_group("mobs")
		velocity = Vector2.ZERO
	else:
		## if alive, hunt player (update direction & move)
		hunt_player(player)
		velocity = velocity.rotated(direction)
		if (player.position - position).length_squared() < 500:
			$AnimatedSprite2D.play("hit1")
			$HitTimer.start()
		else:
			$HitTimer.stop()
			$AnimatedSprite2D.play("run")
			if velocity.x < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().name == 'Player' && hittable:
			hit_player.emit()
			hittable = false
			$HitTimer.start()
		elif 'Tree' in collision.get_collider().name:
			velocity = velocity.slide(collision.get_normal()) * 2
		elif 'arrow' in collision.get_collider().name:
			print("hello")
			_on_arrow_entered()

func hunt_player(_player):
	player = _player
	direction = position.angle_to_point(player.position)
	
func _on_arrow_entered() -> void:
	health -= 10
	hit_goblin.emit()

func _on_death_animation_finished() -> void:
	died.emit()
	queue_free()
	
func _on_hit_timer_timeout() -> void:
	hittable = true
