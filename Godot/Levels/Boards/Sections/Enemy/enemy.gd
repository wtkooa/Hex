extends Spatial

onready var Target = self.get_node("Target")
onready var Power_Container = self.get_node("Power_Container")
onready var Action_Target = self.get_node("Action_Target")


func _ready():
	self.Target.bind(self)


func _on_Player_power_transfer(power):
	Power_Container._on_power_input(power)


func _on_Power_Container_filled(type):
	
	self.queue_free()