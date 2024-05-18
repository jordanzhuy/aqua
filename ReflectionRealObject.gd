extends RigidBody2D

var image 

# Called when the node enters the scene tree for the first time.
@onready var reflection_scene = preload("res://reflection_object.tscn")
func _ready():
	image = reflection_scene.instantiate()
	add_child(image)
	image.gravity_scale = 1
	image.interactable = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var tilemap = $RayCast2D.get_collider()

	if tilemap != null:
		# TODO: logic for move reflection and update, simplify reflection object as non-rigidbody
		var hit_pos = $RayCast2D.get_collision_point()
		image.global_position = hit_pos
