extends Area2D


var speed = 600.0
var direction = Vector2.RIGHT
var range_travelled = 0.0

func _physics_process(delta: float) -> void:
	# Move in the set direction
	var movement = direction * speed * delta
	position += movement
	
	# Range check (delete if it goes too far)
	range_travelled += movement.length()
	if range_travelled > 1000:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	# We only mask Layer 2 (Enemy), so 'body' must be an enemy
	
	# We'll add this method to enemies in Video 5
	# for now, let's just delete them
	if body.has_method("take_damage"):
		body.take_damage()
	else:
		body.queue_free()
		
	queue_free() # Destroy the projectile.
