extends KinematicBody

onready var Target = self.get_node("Focus_Target")
onready var Collecter = self.get_node("Power_Collector")
onready var Elemental_Meter_TX = self.get_node("Element_Meter_TX")
onready var Power_Container = self.get_node("Power_Container")
onready var Beam = self.get_node("Beam")
onready var Blaster = self.get_node("Blaster")
onready var Charging_Sound = self.get_node("Charging_Sound")

export var player_speed = 6.0
export var player_accel = 4.0
export var player_deaccel = 6.0

const UP_VECTOR = Vector3(0.0, 1.0, 0.0)
const GRAVITY_VECTOR = Vector3(0.0, -1.0, .0)
const GRAVITY_FORCE = 9.8
enum ELEMENT {OORA, UNDA, KYDA, CYRA, FLORA, ERDA}

var current_velocity = Vector3()
var frame_elemental_ratio = {ELEMENT.OORA: 0, ELEMENT.UNDA: 0, ELEMENT.KYDA: 0,
						     ELEMENT.CYRA: 0, ELEMENT.FLORA: 0, ELEMENT.ERDA: 0} 
var frame_power_amount = {ELEMENT.OORA: 0, ELEMENT.UNDA: 0, ELEMENT.KYDA: 0,
						  ELEMENT.CYRA: 0, ELEMENT.FLORA: 0, ELEMENT.ERDA: 0} 


func _ready():
	self.Target.bind(self)
	self.Elemental_Meter_TX.bind("Player_Current_Element_Meter")


func _physics_process(delta):
	
	self.fall_handler() ##############################################REMOVE ME
	self.move_handler(delta)
	self.power_handler(delta)
	self.action_handler()
	


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


func power_handler(delta):
	self.frame_elemental_ratio = self.Collecter.determine_elemental_ratio()
	for element in self.frame_power_amount:
		self.frame_power_amount[element] = self.frame_elemental_ratio[element] * delta
	self.Elemental_Meter_TX.transmit(self.frame_elemental_ratio)


func action_handler():
	if Input.is_action_pressed("player_primary_action"):
		self.do_primary_action()
	if Input.is_action_just_released("player_primary_action"):
		self.release_primary_action()
	if Input.is_action_pressed("player_secondary_action"):
		self.do_secondary_action()
	if Input.is_action_just_released("player_secondary_action"):
		self.release_secondary_action()

func do_primary_action():
	if self.Target.get_current_target() == null:
		self.release_primary_action()
		return

	var target = self.Target.get_current_target()
	self.Beam.transmit(self.frame_power_amount, target)


func release_primary_action():
	self.Beam.stop()


func do_secondary_action():
	if self.Power_Container.is_full():
		self.Charging_Sound.stop()
		return
	
	self.Power_Container._on_power_stored(self.frame_power_amount)
	if not self.Charging_Sound.playing:
		self.Charging_Sound.play()


func release_secondary_action():
	var power = self.Power_Container._on_power_released()
	self.Charging_Sound.stop()
	if self.Target.get_current_target() != null:
		var target = self.Target.get_current_target()
		self.Blaster.fire(power, target)
		


func fall_handler(): ###############################################REMOVE ME
	if self.translation.y < -20.0:
		self.translation = Vector3(0.0, 10.0, 0.0)


func _on_Target_detargeted_all():
	if self.Target.get_current_target() != null and Input.is_action_pressed("player_primary_action"):
		self.Beam.visible = false
		self.Audio_Player.stop()
