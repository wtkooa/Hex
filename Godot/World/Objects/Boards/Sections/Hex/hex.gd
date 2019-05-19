extends Spatial

onready var Model = self.get_node("StaticBody/Hex_Mesh")
onready var Power_Source = self.get_node("Power_Source")

var _last_frame_position = Vector3(0.0, 0.0, 0.0)
var _movement_vector = Vector3(0.0, 0.0, 0.0)


export(Fundamental.ELEMENTS) var element

func _ready():
	var surface_level = 0
	self.Power_Source.set_element(element)
	match self.element:
		Fundamental.ELEMENTS.OORA:
			self.Model.set_surface_material(surface_level, load("res://World/Objects/Boards/Sections/Hex/Materials/Oora.material"))
		Fundamental.ELEMENTS.UNDA:
			self.Model.set_surface_material(surface_level, load("res://World/Objects/Boards/Sections/Hex/Materials/Unda.material"))
		Fundamental.ELEMENTS.KYDA:
			self.Model.set_surface_material(surface_level, load("res://World/Objects/Boards/Sections/Hex/Materials/Kyda.material"))
		Fundamental.ELEMENTS.CYRA:
			self.Model.set_surface_material(surface_level, load("res://World/Objects/Boards/Sections/Hex/Materials/Cyra.material"))
		Fundamental.ELEMENTS.FLORA:
			self.Model.set_surface_material(surface_level, load("res://World/Objects/Boards/Sections/Hex/Materials/Flora.material"))
		Fundamental.ELEMENTS.ERDA:
			self.Model.set_surface_material(surface_level, load("res://World/Objects/Boards/Sections/Hex/Materials/Erda.material"))
			

func _physics_process(delta):
	self._movement_vector = self.to_global(self.translation) - self._last_frame_position
	self._last_frame_position = self.to_global(self.translation)


func get_movement_vector():
	return self._movement_vector