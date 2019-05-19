extends Spatial

signal received(power)
signal released()

onready var Bubble = self.get_node("Beam_Bubble")

export var _bubble_radius = 1.0

func _ready():
	self.Bubble.scale = Vector3(self._bubble_radius, self._bubble_radius, self._bubble_radius)


func _on_Beam_transmitted(power, color, angle):
	self.emit_signal("received", power)
	angle = self.to_local(angle)
	
	var angle_orthoganal = angle.cross(Vector3(0.0, 1.0, 0.0)) 
	var required_pitch = angle.angle_to(Vector3(0.0, 1.0, 0.0))
	
	self.Bubble.rotation = Vector3(0.0, 0.0, 0.0)
	
	self.Bubble.look_at(angle, Vector3(0.0, 1.0, 0.0))
	
	self.Bubble.rotate(-angle_orthoganal.normalized(), required_pitch)
	self.Bubble.rotate(angle.normalized(), PI)
	self.Bubble.rotate(Vector3(0.0, 1.0, 0.0), -0.1)
	
	
	
	var ripple = self.Bubble.get_surface_material(0)
	ripple.albedo_color.r = color.r
	ripple.albedo_color.g = color.g
	ripple.albedo_color.b = color.b
	ripple.emission = color
	self.Bubble.visible = true

func _on_Beam_stopped():
	self.Bubble.visible = false


func _on_Target_released():
	self.emit_signal("released")


func get_bubble_radius():
	return self._bubble_radius