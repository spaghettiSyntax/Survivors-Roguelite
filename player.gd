class_name Player
extends CharacterBody2D


# Signals let the UI know when things change
signal experience_gained(growth_data)
signal leveled_up
signal health_changed(current_health)
signal health_depleted


@export var speed = 300.0
@export var health = 100
@export var upgraded_holster = false
@export var projectile_count = 1 # Start with 1 projectile


var experience = 0
var experience_level = 1
var experience_required = 100


func _physics_process(_delta: float) -> void:
	# Get input direction (left, right, up, down)
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Apply Velocity
	velocity = direction * speed
	
	# Handle animation player
	if velocity.x != 0 or velocity.y != 0:
		$AnimationPlayer.play("run")
	else:
		$AnimationPlayer.play("idle")
		
	# Handle sprite flipping
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true

	# Move the character
	move_and_slide()
	
	
func gain_xp(amount):
	experience += amount
	
	# Check for Level Up!
	if experience >= experience_required:
		experience -= experience_required
		level_up()
	
	experience_gained.emit(experience, experience_required)
	
	
func level_up():
	experience_level += 1
	experience_required += 50 # Makes the next level harder
	
	# Pause the game!
	get_tree().paused = true
	
	# Show the UI
	emit_signal("leveled_up")
	

func heal(amount):
	health += amount
	if health > 100:
		health = 100 # Cap health at max
		
	health_changed.emit(health) # Triggers the UI Update
	
	
func take_damage():
	# Check if damage timer is running
	if $DamageTimer.time_left > 0:
		return # We are invincible
		
	# Take damage
	health -= 10
	health_changed.emit(health) # Tell the UI to update!
	
	# Start I-Frames
	$DamageTimer.start()
	
	# Visual feedback
	modulate.a = 0.5
	
	# Check if player has health
	if health <= 0:
		health_depleted.emit()
		
		# Disable collision so enemies stop pushing the corpose
		$CollisionShape2D.set_deferred("disabled", true)
		
		# Optional hide the player
		hide()


func _on_damage_timer_timeout() -> void:
	modulate.a = 1.0
