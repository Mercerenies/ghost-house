extends CPUParticles2D

func _ready():
    emitting = true
    rotation = randf() * 360

func _on_Timer_timeout():
    queue_free()
