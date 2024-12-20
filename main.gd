extends Node

@export var mob_scene: PackedScene
var score
var gameStarted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gameStarted:
		cheat()
		getExtraLife()
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$LifeTimer.stop()
	$HUD.show_game_over(score)
	gameStarted = false

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_life($Player.life)
	$HUD.show_message1("准备")
	clearAllMobs()
	gameStarted = true

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	if score >= 10:
		$HUD.show_message1("按e家暴")
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$LifeTimer.start()

func _on_life_timer_timeout() -> void:
	if score >= 10:
		$HUD.show_message2("按c当龟公")
	$HUD.update_life($Player.life)

func clearAllMobs():
	get_tree().call_group("mobs", "queue_free")

func cheat():
	if score <= 10:
		return

	if Input.is_action_pressed("e"):
		clearAllMobs()
		score -= 10

func getExtraLife():
	if score <= 10:
		return

	if Input.is_action_pressed("c"):
		score -= 10
		$Player.life += 1
