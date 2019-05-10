extends Control

onready var Color_Texture = self.get_node("Color")

enum ELEMENT {OORA, UNDA, KYDA, CYRA, FLORA, ERDA}

func _on_TX_transmitted(elemental_ratio):
	var color = self.calc_elemental_color(elemental_ratio)
	self.Color_Texture.set_self_modulate(color)


func calc_elemental_color(elemental_ratio):
	var color = Vector3(0.5, 0.5, 0.5)
	
	var oora = elemental_ratio[ELEMENT.OORA]
	oora *= 0.5
	color += Vector3(oora, oora, oora)
	
	var unda = elemental_ratio[ELEMENT.UNDA]
	unda *= 0.5
	color -= Vector3(unda, unda, unda)
	
	var kyda = elemental_ratio[ELEMENT.KYDA]
	kyda *= 0.5
	color += Vector3(kyda, 0.0, 0.0)
	
	var cyra = elemental_ratio[ELEMENT.CYRA]
	cyra *= 0.5
	color += Vector3(0.0, 0.0, cyra)
	
	var flora = elemental_ratio[ELEMENT.FLORA]
	flora *= 0.5
	color += Vector3(0.0, flora, 0.0)
	
	var erda = elemental_ratio[ELEMENT.ERDA]
	erda *= 0.5
	color += Vector3(erda, erda, 0.0)
	
	for value in color:
		if value > 1.0:
			value = 1.0
		if value < 0:
			value = 0
	
	return Color(color.x, color.y, color.z, 1.0)