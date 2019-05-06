extends Spatial

onready var Parent = self.get_parent()
onready var Audio_Player = self.get_node("AudioStreamPlayer")

export(float) var speed = 0.5

var target
var fired = false
var power
var global_fired_location
var progress = 0
onready var audio_released = load("res://Audio/Effects/release.wav")
onready var audio_explode = load("res://Audio/Effects/explode.wav")


func fire_at(bound_target, power):
	self.target = bound_target
	bound_target.connect("released", self, "_on_bound_target_released")
	self.global_fired_location = self.to_global(self.translation)
	self.power = power
	self.fired = true
	self.Audio_Player.set_stream(self.audio_released)
	self.Audio_Player.play()

func _physics_process(delta):
	if fired:
		self.progress += speed * delta
		self.speed = pow(1.3, self.speed)
		if self.progress > 1.0:
			self.explode()
		self.translation = Parent.to_local(self.global_fired_location).linear_interpolate(Parent.to_local(self.target.to_global(self.target.Action_Target.translation)), self.progress)


func explode():
	self.target._on_Player_power_transfer(self.power)
	self.Audio_Player.stop()
	self.Audio_Player.set_stream(self.audio_explode)
	self.Audio_Player.play()
	self.visible = false
	self.fired = false

func _on_bound_target_released():
	self.visible = false

func _on_AudioStreamPlayer_finished():
	if self.visible == false:
		self.queue_free()