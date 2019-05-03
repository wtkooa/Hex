extends KinematicBody

const UP_VECTOR = Vector3(0.0, 1.0, 0.0)
const GRAVITY_VECTOR = Vector3(0.0, -1.0, .0)
const GRAVITY_FORCE = 9.8

export var player_speed = 6.0
export var player_accel = 4.0
export var player_deaccel = 6.0

var current_velocity = Vector3()

func _physics_process(delta):
	var gravity = self.GRAVITY_VECTOR * self.GRAVITY_FORCE * delta
	
	var direction = Vector3()
	if Input.is_action_pressed("player_up"):
		direction += Vector3(0.0, 0.0, -1.0)
	if Input.is_action_pressed("player_down"):
		direction += Vector3(0.0, 0.0, 1.0)
	if Input.is_action_pressed("player_left"):
		direction += Vector3(-1.0, 0.0, 0.0)
	if Input.is_action_pressed("player_right"):
		direction += Vector3(1.0, 0.0, 0.0)
	
	direction.y = 0
	direction = direction.normalized()
	var new_position = direction * self.player_speed
	
	self.current_velocity += self.GRAVITY_VECTOR * self.GRAVITY_FORCE * delta

	var horizontal_velocity = self.current_velocity
	horizontal_velocity.y = 0
	
	var current_acceleration
	if direction.dot(horizontal_velocity) > 0:
		current_acceleration = self.player_accel
	else:
		current_acceleration = self.player_deaccel
	
	horizontal_velocity = horizontal_velocity.linear_interpolate(new_position, current_acceleration * delta)
	
	self.current_velocity.x = horizontal_velocity.x
	self.current_velocity.z = horizontal_velocity.z

	self.current_velocity = self.move_and_slide(self.current_velocity, self.UP_VECTOR)