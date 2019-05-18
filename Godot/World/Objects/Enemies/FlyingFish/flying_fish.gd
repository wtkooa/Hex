extends Spatial

signal released

onready var Target = self.get_node("Focus_Target")
onready var Power_Container = self.get_node("Power_Container")


func _ready():
	self.Target.bind(self)
	self.Power_Container.bind("Flying Fish")


func _on_Power_Container_filled(type):
	self.visible = false
	self.emit_signal("released")
	self.queue_free()


func _on_Beam_Target_received(power):
	Power_Container.store(power)


func _on_Blast_Target_received(power):
	Power_Container.store(power)