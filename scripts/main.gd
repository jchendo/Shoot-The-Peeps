extends Node2D

var score = 0
var goblins
@export var damage = 6 ## how much damage the player/enemies take when hit
@export var mob_scene : PackedScene
@export var arrow_scene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass ## play music and stuff
	
func _on_game_start() -> void:
	$MobTimer.start()
	$Player.show()
	$ScoreTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Player.health <= 0:
		$Player.hide()
		$MobTimer.stop()
		$ScoreTimer.stop()
		#for goblin in goblins:
		#	goblin.hide()

func _on_player_hit():
	$Player.get_node("health_bar").size.x -= damage
	$Player.health -= damage

func _on_mob_timer_timeout():
	
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	mob.hunt_player($Player)
	mob.connect("hit_player", _on_player_hit)
	add_child(mob)

func _on_player_shoot() -> void:
	goblins = get_tree().get_nodes_in_group("mobs")
	var arrow = arrow_scene.instantiate()
	var delta = INF
	var target
	for goblin in goblins:
		## shoot at the closest goblin by comparing positions
		if ($Player.position - goblin.position).length_squared() < delta:
			delta = ($Player.position - goblin.position).length_squared()
			target = goblin
	
	delta = target.position - $Player.position ## repurposing delta for animation selection
	if delta.y < -75: ## enemy above
		$Player/Bow_Animation.play("shoot_up")
	elif delta.y > 75: ## below
		$Player/Bow_Animation.play("shoot_down")
	else:
		$Player/Bow_Animation.play("shoot_horizontal")
			
	arrow.position = $Player.position
	arrow.fire(target)
	
	add_child(arrow)

func _increase_score():
	score += 1
	$HUD/ScoreLabel.text = str(score)
	$MobTimer.set_wait_time(1.5-(0.05*score)) ## increase goblin spawn rate
