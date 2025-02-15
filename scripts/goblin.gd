extends CharacterBody2D

signal hit_player
signal hit_goblin
signal died
var dead = false
var health = randi_range(10,30)
var direction = 0
var player ## for hunting purposes
var hittable = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("run")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2(randf_range(150.0, 250), 50)
	remove_from_group("untargetables") ## make mobs targetable again
	if health > 0:
		## if alive, hunt player (update direction & move)
		hunt_player(player)
		velocity = velocity.rotated(direction)
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		var collision = move_and_collide(velocity * delta)
		if collision:
			if collision.get_collider().name == 'Player' && hittable:
				$AnimatedSprite2D.play("hit1")
				hit_player.emit()
				hittable = false
				$HitTimer.start()
			elif 'Tree' in collision.get_collider().name or 'Sheep' in collision.get_collider().name:
				velocity = velocity.slide(collision.get_normal())
				move_and_slide()
			if collision.get_collider().name == 'SafeZone':
				add_to_group("untargetables") ## to make it impossible to shoot them while in safezone
				velocity = velocity.slide(collision.get_normal())
				move_and_slide()
	elif not dead:
		dead = true
		$AnimatedSprite2D.play("death")
		velocity = Vector2.ZERO
		remove_from_group("mobs")
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
	if not dead:
		$AnimatedSprite2D.play("run")
		hittable = true
