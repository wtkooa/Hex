extends Spatial

onready var Target = self.get_node("Target")
onready var Target_Indicator = self.get_node("Crystal_Target_Mesh")
onready var Power_Container = self.get_node("Power_Container")

export var rotation_speed = 0.1


func _ready():
	Target.bind(self)

func _process(delta):
	self.rotate_y(self.rotation_speed * delta)


func _on_Area_mouse_entered():
	self.Target_Indicator.visible = true


func _on_Area_mouse_exited():
	self.Target_Indicator.visible = false


func _on_Target_detargeted(reference):
	self.Target_Indicator.visible = false


func _on_Player_power_transfer(power):
	Power_Container._on_power_input(power)

func _on_Power_Container_filled(type):
	print("You win!")
