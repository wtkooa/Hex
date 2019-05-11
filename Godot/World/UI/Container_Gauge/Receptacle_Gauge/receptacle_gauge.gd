extends Control

onready var Element_Label = self.get_node("HBoxContainer/NinePatchRect/Element_Label")
onready var Capacity_Label = self.get_node("HBoxContainer/NinePatchRect2/Capacity_Label")
onready var Progress_Bar = self.get_node("HBoxContainer/TextureProgress")

var max_capacity = 0

func setup(type, current_amount, max_capacity):
	
	self.max_capacity = max_capacity
	
	match type:
		"Total":
			self.Element_Label.text = "Total"
		Fundamental.ELEMENTS.OORA:
			self.Element_Label.text = "Oora"
			self.set_texture_color(Color(0.9, 0.9, 0.9, 1.0))
		Fundamental.ELEMENTS.UNDA:
			self.Element_Label.text = "Unda"
			self.set_texture_color(Color(0.235, 0.235, 0.235, 1.0))
		Fundamental.ELEMENTS.KYDA:
			self.Element_Label.text = "Kyda"
			self.set_texture_color(Color(1.0, 0.5, 0.5, 1.0))
		Fundamental.ELEMENTS.CYRA:
			self.Element_Label.text = "Cyra"
			self.set_texture_color(Color(0.5, 0.5, 1.0, 1.0))
		Fundamental.ELEMENTS.FLORA:
			self.Element_Label.text = "Flora"
			self.set_texture_color(Color(0.5, 1.0, 0.5, 1.0))
		Fundamental.ELEMENTS.ERDA:
			self.Element_Label.text = "Erda"
			self.set_texture_color(Color(1.0, 1.0, 0.5, 1.0))
	
	self.Progress_Bar.step = 0.01
	if not max_capacity == -1:
		self.Progress_Bar.max_value = max_capacity
		self.Progress_Bar.value = current_amount
		self.Capacity_Label.text = str(ceil(current_amount)) + "/" + str(floor(max_capacity))
	else:
		self.Progress_Bar.max_value = 1
		self.Progress_Bar.value = 0
		self.Capacity_Label.text = str(ceil(current_amount)) + "/INF"
	self.visible = true


func set_texture_color(new_color):
	self.Progress_Bar.tint_under = new_color
	self.Progress_Bar.tint_over = new_color
	self.Progress_Bar.tint_progress = new_color


func update_amount(new_amount):
	if not max_capacity == -1:
		self.Progress_Bar.value = new_amount
		self.Capacity_Label.text = str(ceil(new_amount)) + "/" + str(floor(self.max_capacity))
	else:
		self.Capacity_Label.text = str(ceil(new_amount)) + "/INF"