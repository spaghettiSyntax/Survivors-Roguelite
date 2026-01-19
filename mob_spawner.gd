extends Node2D


@export var enemy_scene: PackedScene


@onready var spawn_path = %PathFollow2D


func _on_timer_timeout() -> void:
	# Create the enemy
	var new_enemy = enemy_scene.instantiate()
	
	# Pick a random spot on the path
	spawn_path.progress_ratio = randf()
	new_enemy.global_position = spawn_path.global_position
	
	# Pass the player reference
	# Since this script is a child of the Player, get_parent() IS the Player
	new_enemy.player_reference = get_parent()
	
	# Add enemy to the world (not the player, or they will move with us!)
	get_tree().current_scene.add_child(new_enemy)
