extends CharacterBody2D



var GRAVITY = 2500

var velocity_decrement = 0
var double_jump = true
var in_water = 0
var pickup = null

var NORMAL_SPEED = 160
var NORMAL_SPEED_DECREMENT = 100
var NORMAL_AIR_SPEED = 120
var NORMAL_AIR_SPEED_DECREMENT = 20
var WATER_SPEED = 160
var WATER_SPEED_DECREMENT = 100
	
func alter_world():
	in_water = 0 if in_water == 1 else 1
	
	
var in_range = false
func _process(delta):
	pass
				
				
func _physics_process(delta):
	
	if is_on_floor():
		double_jump = true
		
	# currently use space to shift between water physics and real physics
	if Input.is_action_just_pressed("alter_world"):
		alter_world()
		
	var max_speed = 400 if in_water == 0 else 300 

	# Add the gravity.
	if not is_on_floor():
		if in_water == 0:
			velocity.y += GRAVITY * delta
		
	if Input.is_action_just_pressed("pickup"):
		# need to switch between objects when multiple one are near
		if picking == false and pickup == null:
			var bodies = $PickRange.get_overlapping_bodies()
			if len(bodies) == 0:
				pass
			else:
				# TODO: When picking up, need to check for rigidbody's position in case it stuck in other things
				picking = true
				pickup = bodies[0]
				pickup.reparent(self,false)
				pickup.position = Vector2(0,0)
				var picked_shape = bodies[0].get_node("CollisionShape2D")
				var shape_relative_transform = picked_shape.transform
				var dup_shape = picked_shape.duplicate()
				
				# TODO: need to fix transform between shape and rect
				$PickedObject.add_child(dup_shape)
				dup_shape.transform = shape_relative_transform
				pickup.disable_physics()
				
		else:
			picking = false
			$PickedObject/CollisionShape2D.queue_free()
			pickup.enable_physics()
			# TODO: May be changed. currently returning node to parent. 
			pickup.reparent(get_parent(), true)
			pickup = null
			
			
			
			
			
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if !in_water:
			if is_on_floor():
				velocity.y = -600
			elif double_jump:
				velocity.y = -600
				double_jump = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		
	var direction = Input.get_axis("move_left", "move_right")
	var v_direction = Input.get_axis("jump", "move_down")

	
	if !in_water:
		if is_on_floor():
			if direction:
				velocity.x = move_toward(velocity.x, direction*max_speed, NORMAL_SPEED)
			else:
				velocity.x = move_toward(velocity.x, 0, NORMAL_SPEED_DECREMENT)
		if !is_on_floor():
			if direction:
				velocity.x = move_toward(velocity.x, direction*max_speed, NORMAL_AIR_SPEED)
			else:
				velocity.x = move_toward(velocity.x, 0, NORMAL_AIR_SPEED_DECREMENT)
	else:
		if v_direction:
			velocity.y = move_toward(velocity.y, v_direction*max_speed, WATER_SPEED)
		else:
			velocity.y = move_toward(velocity.y, 0, WATER_SPEED_DECREMENT)
		if is_on_floor():
			if direction:
				velocity.x = move_toward(velocity.x, direction*max_speed, WATER_SPEED)
			else:
				velocity.x = move_toward(velocity.x, 0, WATER_SPEED_DECREMENT)
		if !is_on_floor():
			if direction:
				velocity.x = move_toward(velocity.x, direction*max_speed, WATER_SPEED)
			else:
				velocity.x = move_toward(velocity.x, 0, WATER_SPEED_DECREMENT)
	#if $Pickup.has_overlapping_bodies():
		#velocity = Vector2i(0,0)
	var collision = $PickedObject.move_and_collide(velocity * delta, true)
	if collision == null:
		move_and_slide()
	else:
		velocity = velocity.slide(collision.get_normal())
		var collision_2 = $PickedObject.move_and_collide(velocity * delta, true)
		if collision_2 == null:
			move_and_slide()
		else:
			velocity = Vector2(0,0)
			move_and_slide()
	


var picking = false

func _on_pick_range_body_entered(body):
	print("body entered")