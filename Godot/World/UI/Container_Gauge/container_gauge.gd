extends Control

onready var Object_Name_Label = self.get_node("VBoxContainer/NinePatchRect/Object_Label")
onready var Receptacle_Root = self.get_node("VBoxContainer/Receptacle_Root")
export(PackedScene) var Receptacle

var current_reference = null

func _on_Container_targeted(reference):
	if self.current_reference == reference:
		return
	
	if not self.current_reference == null:
		self.current_reference.disconnect("transmitted", self, "_on_Container_transmitted")
	self.current_reference = reference
	reference.connect("transmitted", self, "_on_Container_transmitted")
	reference.connect("released", self, "_on_Container_released")
	var data = reference.data()
	var new_name = data[0]
	var total_data = data[1]
	var elemental_receptacles = data[2]
	
	Object_Name_Label.set_text(new_name)
	self.clear_receptacles()
	self.generate_total_receptacle(total_data)
	self.generate_elemental_receptacles(elemental_receptacles)	


func clear_receptacles():
	var receptacles = self.Receptacle_Root.get_children()
	for receptacle in receptacles:
		receptacle.queue_free()


func generate_total_receptacle(data):
	var total_receptacle_gauge = self.Receptacle.instance()
	var total_current_amount = data[0]
	var total_max_capacity = data[1]
	self.Receptacle_Root.add_child(total_receptacle_gauge)
	total_receptacle_gauge.setup("Total", total_current_amount, total_max_capacity)
	


func generate_elemental_receptacles(elemental_receptacles):
	for receptacle in elemental_receptacles:
		var type = receptacle.type()
		var current_amount = receptacle.current_amount()
		var max_capacity = receptacle.max_capacity()
		var elemental_receptacle_gauge =  self.Receptacle.instance()
		self.Receptacle_Root.add_child(elemental_receptacle_gauge)
		elemental_receptacle_gauge.setup(type, current_amount, max_capacity)


func _on_Container_transmitted(data):
	
	var total_data = data[1]
	var elemental_receptacles = data[2]
	var total_current_amount = total_data[0]
	
	var receptacle_gauges = self.Receptacle_Root.get_children()
	var total_receptacle_gauge = receptacle_gauges.pop_front()
	total_receptacle_gauge.update_amount(total_current_amount)
	for receptacle in elemental_receptacles:
		var array_element_number = elemental_receptacles.find(receptacle)
		var new_amount = receptacle.current_amount()
		receptacle_gauges[array_element_number].update_amount(new_amount)

func _on_Container_released():
	self.clear_receptacles()
	Object_Name_Label.set_text("")
	self.current_reference = null
	