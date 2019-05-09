extends Spatial

onready var Model = self.get_node("StaticBody/Hex_Mesh")
onready var Power_Source = self.get_node("Power_Source")

enum ELEMENT {OORA, UNDA, KYDA, CYRA, FLORA, ERDA}
export(ELEMENT) var element

func _ready():
	var surface_level = 0
	self.Power_Source.set_element(element)
	match self.element:
		ELEMENT.OORA:
			self.Model.set_surface_material(surface_level, load("res://Levels/Boards/Sections/Hex/Materials/Oora.material"))
		ELEMENT.UNDA:
			self.Model.set_surface_material(surface_level, load("res://Levels/Boards/Sections/Hex/Materials/Unda.material"))
		ELEMENT.KYDA:
			self.Model.set_surface_material(surface_level, load("res://Levels/Boards/Sections/Hex/Materials/Kyda.material"))
		ELEMENT.CYRA:
			self.Model.set_surface_material(surface_level, load("res://Levels/Boards/Sections/Hex/Materials/Cyra.material"))
		ELEMENT.FLORA:
			self.Model.set_surface_material(surface_level, load("res://Levels/Boards/Sections/Hex/Materials/Flora.material"))
		ELEMENT.ERDA:
			self.Model.set_surface_material(surface_level, load("res://Levels/Boards/Sections/Hex/Materials/Erda.material"))