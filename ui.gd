extends CanvasLayer


@export var player: CharacterBody2D


@onready var xp_bar = $ProgressBar


func _ready():
	# Initialize bar
	xp_bar.value = 0
	xp_bar.max_value = 100
	$HealthBar.value = 100
	
	# Connect to player, but safely
	if player:
		player.experience_gained.connect(_on_experience_gained)
		player.leveled_up.connect(_on_level_up)
		player.health_changed.connect(_on_player_health_changed)
		player.health_depleted.connect(_on_game_over)
	
	
func _on_experience_gained(current, max_xp):
	xp_bar.value = current
	xp_bar.max_value = max_xp
	
	
func _on_level_up():
	$LevelUpPanel.visible = true


func _resume_game():
	$LevelUpPanel.visible = false
	get_tree().paused = false # Unfreezes the game!
	
	
func _on_heal_button_pressed() -> void:
	# Trigger health update
	player.heal(20)
	_resume_game()


func _on_speed_button_pressed() -> void:
	player.speed += 50
	_resume_game()


func _on_damage_button_pressed() -> void:
	# Add 1 to projectile count, but stop we hit 3
	player.projectile_count = min(player.projectile_count + 1, 3)
	_resume_game()
	

func _on_player_health_changed(new_health):
	$HealthBar.value = new_health
	

func _on_game_over():
	$GameOverPanel.visible = true
	get_tree().paused = true


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
