extends Node2D

var score = 0
var goblins
@export var damage = 6 ## how much damage the player/enemies take when hit
@export var mob_scene : PackedScene
@export var arrow_scene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Music.play()
	
func _on_game_start() -> void:
	
	set_process(true)
	$SafeZone.show()
	$Music.stream_paused = false
	score = 0
	
	$MobTimer.set_wait_time(1.5)
	$Player.health = 60
	$Player/health_bar.size.x = 60
	$Player.position = Vector2(630,275)
	$Player.show()
	
	$MobTimer.start()

func _on_game_over() -> void:
	$Music.stream_paused = true
	$Music.play()
	$Death.play()
	$GameOver.play()
	$Player.hide()
	$MobTimer.stop()
	$HUD/Title.text = 'Game Over!!'
	$HUD/Title.show()
	$HUD/GameOverTimer.start()
	for goblin in goblins:
		goblin.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	goblins = get_tree().get_nodes_in_group("mobs")
	if $Player.health <= 0:
		_on_game_over()
		set_process(false)
		
func _on_player_hit():
	$Player.get_node("health_bar").size.x -= damage
	$Player.health -= damage

func _on_mob_timer_timeout():
	
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	mob.hunt_player($Player)
	mob.connect("died", _increase_score)
	mob.connect("hit_player", _on_player_hit)
	mob.connect("hit_goblin", _on_goblin_hit)
	add_child(mob)

func _on_player_shoot() -> void:
	var arrow = arrow_scene.instantiate()
	var delta = INF
	var target
	if not get_tree().get_nodes_in_group("mobs").is_empty():
		for goblin in goblins:
			## shoot at the closest goblin by comparing positions
			if goblin not in get_tree().get_nodes_in_group("untargetables"):
				if ($Player.position - goblin.position).length_squared() < delta:
					delta = ($Player.position - goblin.position).length_squared()
					target = goblin
				else:
					continue
			else:
				continue
		if target != null:
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
		else:
			pass

func _increase_score():
	score += 1
	$HUD/ScoreLabel.text = str(score)
	$MobTimer.set_wait_time(1.5-(0.025*score)) ## increase goblin spawn rate

func _on_goblin_hit():
	pass
