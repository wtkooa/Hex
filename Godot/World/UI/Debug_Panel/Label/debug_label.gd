extends Label

export(String) var label = "Unlabled"


func update_text(message):
	self.text = label + ": " + message