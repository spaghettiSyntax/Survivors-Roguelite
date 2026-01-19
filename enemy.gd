extends CharacterBody2D


@export var speed = 100.0
@export var player_reference: CharacterBody2D
@export var loot_scene: PackedScene


func _physics_process(_delta: float) -> void:
	if player_reference:
		# If we are too far (eg 2000px), delete ourselves
		if global_position.distance_to(player_reference.global_position) > 2000:
			queue_free()

		# Calculate direction to the player
		var direction = global_position.direction_to(player_reference.global_position)
		
		# Move towards player
		velocity = direction * speed
		
		# Handle animation player
		if velocity.x != 0 or velocity.y != 0:
			$AnimationPlayer.play("run")
		
		# Handle sprite flipping
		if velocity.x > 0:
			$Sprite2D.flip_h = false
		elif velocity.x < 0:
			$Sprite2D.flip_h = true
		
		# Move the enemy
		move_and_slide()
		
		# Attack Logic
		var targets = $Hitbox.get_overlapping_bodies()
		for target in targets:
			if target is Player: 
				target.take_damage()
		
func take_damage():
	# Visual Feedback
	$Sprite2D.modulate = Color(10, 10, 10)
	
	# Create a Tween to fade back to normal color
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.1)
	
	# Wait for the tween to finish
	await tween.finished
	
	# Spawn the gem
	var new_gem = loot_scene.instantiate()
	new_gem.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", new_gem)
	
	# Die
	queue_free()
