extends Area2D

signal water_state_changed(in_water : int)

var in_water : int = 0;

func _on_body_entered(body):
	if(in_water == 0):
		var overlapping_bodies = get_overlapping_bodies()
		if(overlapping_bodies.size() >= 1):
			in_water = 1
			emit_signal("water_state_changed", in_water)

func _on_body_exited(body):
	var overlapping_bodies = get_overlapping_bodies()
	if(overlapping_bodies.size() == 0):
		in_water = 0
		emit_signal("water_state_changed", in_water)
		
