extends Area2D

signal hit_player
var health = 20
var direction
var player ## for hunting purposes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("run")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2(randf_range(100.0, 200.0), 0)
	if health <= 0:
		$AnimatedSprite2D.play("death")
		remove_from_group("mobs")
		velocity = Vector2.ZERO
	## if alive, hunt player (update direction & move)
	hunt_player(player)
	velocity = velocity.rotated(direction)
	if (player.position - position).length_squared() < 500:
		pass
	else:
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		position += velocity * delta

func hunt_player(_player):
	player = _player
	direction = position.angle_to_point(player.position)

func _on_player_hit(body: Node2D) -> void:
	hit_player.emit()
	
func _on_arrow_entered(area: Area2D) -> void:
	health -= 10

func _on_death_animation_finished() -> void:
	queue_free()
	
