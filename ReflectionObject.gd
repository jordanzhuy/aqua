extends RigidBody2D

signal picked_up(obj)
const gravity = Vector2(100,0) #direction of gravity

@export var interactable := false

var image = null

func _ready():
	gravity_scale = 1
	set_physics_process(true)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$LabelPos.global_rotation = 0


func disable_physics():
	freeze = true
	$CollisionShape2D.disabled = true
	$Area2D.monitoring = false
	
func enable_physics():
	freeze = false
	$CollisionShape2D.disabled = false
	$Area2D.monitoring = true
	
func _on_area_2d_body_entered(body):
	if interactable:
		$LabelPos.visible = true
	

func _on_area_2d_body_exited(body):
	if interactable:
		$LabelPos.visible = false
	


func _on_input_event(viewport, event, shape_idx):
	pass
		
func move_to(pos):
	move_and_collide(pos)
