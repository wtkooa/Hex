extends Spatial

signal defeated

onready var Target = self.get_node("Target")
onready var Power_Container = self.get_node("Power_Container")
onready var Action_Target = self.get_node("Action_Target")
onready var Audio_Player = self.get_node("AudioStreamPlayer")

onready var audio_death = load("res://Audio/Effects/deathd.wav")


func _ready():
	self.Target.bind(self)


func _on_Player_power_transfer(power):
	Power_Container._on_power_input(power)


func _on_Power_Container_filled(type):
	self.emit_signal("defeated")
	self.Audio_Player.set_stream(self.audio_death)
	self.Audio_Player.play()
	self.visible = false
	

func _on_AudioStreamPlayer_finished():
	self.queue_free()
