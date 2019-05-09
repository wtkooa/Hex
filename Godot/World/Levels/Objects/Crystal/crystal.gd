extends Spatial

signal released

onready var Target = self.get_node("Focus_Target")
onready var Target_Indicator = self.get_node("Crystal_Target_Mesh")
onready var Power_Container = self.get_node("Power_Container")

export var rotation_speed = 0.1


func _ready():
	Target.bind(self)

func _process(delta):
	self.rotate_y(self.rotation_speed * delta)


func _on_Area_mouse_entered():
	self.Target_Indicator.visible = true


func _on_Power_Container_filled(type):
	print("You win!")


func _on_Beam_Target_received(power):
	Power_Container._on_power_stored(power)


func _on_Mouse_Pick_Area_mouse_entered():
	self.Target_Indicator.visible = true


func _on_Mouse_Pick_Area_mouse_exited():
	self.Target_Indicator.visible = false


func _on_Blast_Target_received(power):
	Power_Container._on_power_stored(power)
