extends Node2D

var score
@export var damage = 6 ## how much damage the player/enemies take when hit
@export var mob_scene : PackedScene
@export var arrow_scene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MobTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_hit() -> void:
	$Player.get_node("health_bar").size.x -= damage
	$Player.health -= damage

func _on_mob_timer_timeout():
	
	var mob = mob_scene.instantiate()
	var velocity = Vector2(randf_range(150.0, 250.0), 0)
	var mob_spawn_location = $MobPath/MobSpawnLocation
	var direction = 0
	
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	direction = mob.position.angle_to_point($Player.position)
	
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_player_shoot() -> void:
	var arrow = arrow_scene.instantiate()
	arrow.position = $Player.position
	var direction = arrow.position.angle_to_point($MobPath/MobSpawnLocation.position)
	var velocity = Vector2(100, 0)
	
	arrow.position += velocity
	
	add_child(arrow)
