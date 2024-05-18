extends CharacterBody2D



var GRAVITY = 1500

var velocity_decrement = 0
var in_water = 0
var pickup = null

var NORMAL_SPEED = 100
var NORMAL_SPEED_DECREMENT = 50
var NORMAL_AIR_SPEED = 80
var NORMAL_AIR_SPEED_DECREMENT = 15
var WATER_SPEED = 50
var WATER_SPEED_DECREMENT = 30
var WATER_GRAVITY = 0.1
var JUMP_POWER = 600
@onready var sprite_2d = $AnimatedSprite2D
	
func alter_world():
	in_water = 0 if in_water == 1 else 1
	
	
var in_range = false
func _process(delta):
	pass
				
				
func _physics_process(delta):
	
		
	# currently use space to shift between water physics and real physics
	if Input.is_action_just_pressed("alter_world"):
		alter_world()
		
	var max_speed = 200 if in_water == 0 else 100 

	# Add the gravity.
	if not is_on_floor():
		if in_water == 0:
			velocity.y += GRAVITY * delta
		else:
			velocity.y += GRAVITY * delta * WATER_GRAVITY
			
		
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
			
	if velocity.x > 0:
		sprite_2d.flip_h = true
	elif velocity.x < 0:
		sprite_2d.flip_h = false
			
			
			
			
			
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if !in_water:
			if is_on_floor():
				velocity.y = -JUMP_POWER
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		
	var direction = Input.get_axis("move_left", "move_right")
	var v_direction = Input.get_axis("jump", "move_down")

	# @TODO: Fine-tune for jumping out of water
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

#@TODO: Maybe change this so state change only when water detection area in fully in water
func _on_water_detection_water_state_changed(in_water : int):
	self.in_water = in_water
	
	# temp: reset y velocity when in water
	if in_water:
		velocity.y = 160
	print(in_water)
