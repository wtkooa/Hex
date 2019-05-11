extends Spatial

onready var Model = self.get_node("StaticBody/Hex_Mesh")
onready var Power_Source = self.get_node("Power_Source")


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