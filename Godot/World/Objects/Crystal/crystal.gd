extends Spatial

signal released

onready var Target = self.get_node("Focus_Target")
onready var Power_Container = self.get_node("Power_Container")

export var rotation_speed = 0.1


func _ready():
	self.Target.bind(self)
	self.Power_Container.bind(self.name)

func _process(delta):
	self.rotate_y(self.rotation_speed * delta)


func _on_Power_Container_filled(type):
	print("You win!")


func _on_Beam_Target_received(power):
	Power_Container.store(power)


func _on_Blast_Target_received(power):
	Power_Container.store(power)
