extends Control

export(bool) var is_visible = true
var panel_visible = false

onready var Debug_Panel = self.get_node("VBoxContainer/NinePatchRect")
onready var Label_Root = self.get_node("VBoxContainer/NinePatchRect/VBoxContainer")

func _ready():
	self.visible = self.is_visible
	self.Debug_Panel.visible = false


func _on_TextureButton_pressed():
	print("Debug Pressed")
	if self.Debug_Panel.visible == false:
		self.Debug_Panel.visible = true
	else:
		self.Debug_Panel.visible = false


func _on_Debug_message(name, message):
	var UI_Label = Label_Root.get_node(name)
	UI_Label.update_text(message)