extends Node

var _power = {Fundamental.ELEMENTS.OORA: 0.0,
			  Fundamental.ELEMENTS.UNDA: 0.0,
			  Fundamental.ELEMENTS.KYDA: 0.0,
			  Fundamental.ELEMENTS.CYRA: 0.0,
			  Fundamental.ELEMENTS.FLORA: 0.0,
			  Fundamental.ELEMENTS.ERDA: 0.0}


func set_power(power):
	for element in self._power:
		self._power[element] = power.pop_front()


func get_power():
	var power = []
	for element in self._power:
		power.append(self._power[element])
	return power


func set_element(element, amount):
	self._power[element] = amount


func get_element(element):
	return self._power[element]


func magnitude():
	var amount = 0
	for element in self._power:
		amount += self._power[element]
	return amount

func clear():
	for element in self._power:
		self._power[element] = 0.0

func normalize():
	var total = self.magnitude()
	for element in self._power:
		if total == 0:
			self._power[element] = 0
		else:
			self._power[element] = self._power[element] / total