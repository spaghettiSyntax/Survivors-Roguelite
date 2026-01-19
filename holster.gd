extends Node2D


@export var projectile_scene: PackedScene


@onready var range_finder = $RangeFinder
@onready var player = get_parent()


func _on_timer_timeout() -> void:
	# Loop through our projectile count (1, 2, or 3)
	for i in range(player.projectile_count):
			
		# Get all enemies in range
		var enemies_in_range = range_finder.get_overlapping_bodies()
		
		# If no enemies, stop here
		if enemies_in_range.size() == 0: return
			
		# Find the closest one
		var target_enemy = null
		var shortest_distance = INF # Start with "Infinite" distance
		
		for enemy in enemies_in_range:
			# Measure distance from Holster to Enemy
			var distance = global_position.distance_to(enemy.global_position)
			
			if distance < shortest_distance:
				shortest_distance = distance
				target_enemy = enemy
				
		# Fire at the winner
		if target_enemy: shoot(target_enemy)
			
		# Delay for extra shots
		# Wait 0.1s before the shot, but only if we have shots left
		if i < player.projectile_count - 1:
			await get_tree().create_timer(0.1).timeout
		
		
func shoot(target):
	var new_projectile = projectile_scene.instantiate()
	
	# Set starting position to the Holster's position
	new_projectile.global_position = global_position
	
	# Calculate direction to target
	var direction_to_target = global_position.direction_to(target.global_position)
	new_projectile.direction = direction_to_target
	
	# Rotate projectile visually to face target
	new_projectile.look_at(target.global_position)
	
	# Add to the MAIN world
	get_tree().current_scene.add_child(new_projectile)
