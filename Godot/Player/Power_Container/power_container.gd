extends Spatial

signal filled(type)

export var max_total_capacity = -1
export var max_OORA_capacity = -1
export var max_UNDA_capacity = -1
export var max_KYDA_capacity = -1
export var max_CYRA_capacity = -1
export var max_FLORA_capacity = -1
export var max_ERDA_capacity = -1

enum ELEMENT {OORA, UNDA, KYDA, CYRA, FLORA, ERDA}
var current_power_levels = {"TOTAL": 0, ELEMENT.OORA: 0, ELEMENT.UNDA: 0, ELEMENT.KYDA: 0,
				    ELEMENT.CYRA: 0, ELEMENT.FLORA: 0, ELEMENT.ERDA: 0}
onready var max_power_capacities = {"TOTAL": self.max_total_capacity,
									ELEMENT.OORA: self.max_OORA_capacity,
									ELEMENT.UNDA: self.max_UNDA_capacity,
									ELEMENT.KYDA: self.max_KYDA_capacity,
							        ELEMENT.CYRA: self.max_CYRA_capacity,
									ELEMENT.FLORA: self.max_FLORA_capacity,
									ELEMENT.ERDA: self.max_ERDA_capacity}


func _on_power_input(power):
	for element in power:
		
		var theoretical_total_level = self.current_power_levels["TOTAL"] + power[element]
		var theoretical_elemental_level = self.current_power_levels[element] + power[element]
		var has_free_space = self.max_power_capacities["TOTAL"] > theoretical_total_level or self.max_power_capacities["TOTAL"] == -1
		var has_free_elemental_space = self.max_power_capacities[element] > theoretical_elemental_level or self.max_power_capacities[element] == -1
		
		if has_free_space and has_free_elemental_space:
			self.current_power_levels["TOTAL"] = theoretical_total_level
			self.current_power_levels[element] = theoretical_elemental_level
		
		else:
			var remaining_total_capacity = self.max_power_capacities["TOTAL"] - self.current_power_levels["TOTAL"]
			var remaining_elemental_capacity = self.max_power_capacities[element] - self.current_power_levels[element]

			if remaining_elemental_capacity < 0 or remaining_total_capacity < 0:
				remaining_elemental_capacity = 0
				remaining_total_capacity = 0

			var minimum_acceptable_power = [remaining_total_capacity, remaining_elemental_capacity].min()
			self.current_power_levels["TOTAL"] += minimum_acceptable_power 
			self.current_power_levels[element] += minimum_acceptable_power
			if minimum_acceptable_power == remaining_total_capacity:
				self.emit_signal("filled", "TOTAL")
			else:
				self.emit_signal("filled", element)


func _on_power_output():
	var power = {ELEMENT.OORA: 0, ELEMENT.UNDA: 0, ELEMENT.KYDA: 0,
				 ELEMENT.CYRA: 0, ELEMENT.FLORA: 0, ELEMENT.ERDA: 0}
	for element in power:
		power[element] = self.current_power_levels[element]
	self.zero_container()
	return power


func zero_container():
	for data in self.current_power_levels:
		self.current_power_levels[data] = 0