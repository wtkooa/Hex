extends KinematicBody

onready var Target = self.get_node("Target")
onready var Collecter = self.get_node("Power_Collector")
onready var Power_Container = self.get_node("Power_Container")
onready var Beam = self.get_node("Beam")
onready var Action_Target = self.get_node("Action_Target")
onready var Audio_Player = self.get_node("AudioStreamPlayer")

export var player_speed = 6.0
export var player_accel = 4.0
export var player_deaccel = 6.0

const UP_VECTOR = Vector3(0.0, 1.0, 0.0)
const GRAVITY_VECTOR = Vector3(0.0, -1.0, .0)
const GRAVITY_FORCE = 9.8
enum ELEMENT {OORA, UNDA, KYDA, CYRA, FLORA, ERDA}
var blast_path = "res://Player/Blast/Blast.tscn"
onready var beam_audio = load("res://Audio/Effects/beam.wav")
onready var charging_audio = load("res://Audio/Effects/charging.wav")


var current_velocity = Vector3()


func _ready():
	self.Target.bind(self)


func _physics_process(delta):
	
	self.fall_handler() ##############################################REMOVE ME
	self.move_handler(delta)
	self.action_handler(delta)


func move_handler(delta):
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


func action_handler(delta):
	if Input.is_action_pressed("player_primary_action"):
		self.do_primary_action(delta)
	if Input.is_action_just_released("player_primary_action"):
		self.release_primary_action()
	if Input.is_action_pressed("player_secondary_action"):
		self.do_secondary_action(delta)
	if Input.is_action_just_released("player_secondary_action"):
		self.release_secondary_action()

func do_primary_action(delta):
	if self.Target.get_current_target() == null:
		return
	
	var power = self.Collecter._on_Player_power_requested()
	var power_delta = power
	for element in power:
		power_delta[element] = power[element] * delta
	if self.Target.get_current_target() != null:
		var bound_target = self.Target.get_current_target().get_bound_object()
		bound_target._on_Player_power_transfer(power)
		self.Beam.points = [self.to_global(self.Action_Target.translation), bound_target.to_global(bound_target.Action_Target.translation)]
		if not self.Audio_Player.playing:
			self.Audio_Player.set_stream(self.beam_audio)
			self.Audio_Player.play()
			self.Beam.visible = true
		


func release_primary_action():
	self.Beam.visible = false
	self.Audio_Player.stop()


func do_secondary_action(delta):
	var power = self.Collecter._on_Player_power_requested()
	var power_delta = power
	for element in power:
		power_delta[element] = power[element] * delta
	self.Power_Container._on_power_input(power)
	if not self.Audio_Player.playing:
		self.Audio_Player.set_stream(self.charging_audio)
		self.Audio_Player.play()


func release_secondary_action():
	var power = self.Power_Container._on_power_output()
	self.Audio_Player.stop()
	if self.Target.get_current_target() != null:
		self.fire_blast(power)
		


func fire_blast(power):
	var Blast = load(self.blast_path).instance()
	self.add_child(Blast)
	Blast.translation = self.Action_Target.translation
	var bound_target = self.Target.get_current_target().get_bound_object()
	Blast.fire_at(bound_target, power)


func fall_handler(): ###############################################REMOVE ME
	if self.translation.y < -20.0:
		self.translation = Vector3(0.0, 10.0, 0.0)


func _on_Target_detargeted_all():
	if self.Target.get_current_target() != null and Input.is_action_pressed("player_primary_action"):
		self.Beam.visible = false
		self.Audio_Player.stop()
