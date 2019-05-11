extends Spatial

signal released

onready var Target = self.get_node("Focus_Target")
onready var Power_Container = self.get_node("Power_Container")
onready var Death_Sound = self.get_node("Death_Sound")


func _ready():
	self.Target.bind(self)


func _on_Power_Container_filled(type):
	self.visible = false
	self.emit_signal("released")
	self.Death_Sound.play()
	yield(self.Death_Sound, "finished")
	self.queue_free()


func _on_Beam_Target_received(power):
	Power_Container.store(power)


func _on_Blast_Target_received(power):
	Power_Container.store(power)
