extends CPUParticles2D

func _on_Timer_timeout():
    if emitting:
        emitting = false
    else:
        queue_free()
