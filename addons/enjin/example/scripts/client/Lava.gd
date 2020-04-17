extends Area2D
signal player_out_of_bounds

func _on_body_entered(body):
    if body == get_tree().get_nodes_in_group("player")[0]:
        if $SFX.playing:
            $SFX.stop()
        $SFX.play(0)
        
        emit_signal("player_out_of_bounds")
