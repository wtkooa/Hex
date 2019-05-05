extends Spatial

onready var Collector = self.get_node("Collection_Field")
onready var collection_field_radius = self.get_node("Collection_Field/CollisionShape").shape.radius

enum ELEMENT {OORA, UNDA, KYDA, CYRA, FLORA, ERDA}


func _on_Player_power_requested():
	var power_sources = self.Collector.get_overlapping_areas()
	var refined_power = self.refine(power_sources)
	return refined_power


func refine(power_sources):
	var distances = self.calc_source_distances(power_sources)
	var end_field_distances = self.calc_end_field_distances(distances)
	var power_source_ratios = self.calc_power_source_ratios(end_field_distances)
	var refined_power = self.calc_elemental_ratios(power_sources, power_source_ratios)
	return refined_power


func calc_source_distances(power_sources):
	var self_global_translation = self.to_global(self.translation)
	var distances = []
	for source in power_sources:
		var source_global_translation = source.to_global(source.translation)
		var distance = self_global_translation.distance_to(source_global_translation)
		distances.append(distance)
	return distances


func calc_end_field_distances(distances):
	var end_field_distances = []
	for distance in distances:
		var end_field_distance = self.collection_field_radius - distance
		if end_field_distance < 0:
			end_field_distance = 0
		end_field_distances.append(end_field_distance)
	return end_field_distances


func calc_power_source_ratios(end_field_distances):
	var total_end_field_distance = 0
	for distance in end_field_distances:
		total_end_field_distance += distance
	if total_end_field_distance == 0:
		return [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	var power_source_ratios = []
	for distance in end_field_distances:
		power_source_ratios.append(distance / total_end_field_distance)
	return power_source_ratios


func calc_elemental_ratios(power_sources, power_source_ratios):
	var refined_power = {ELEMENT.OORA: 0, ELEMENT.UNDA: 0, ELEMENT.KYDA: 0,
						 ELEMENT.CYRA: 0, ELEMENT.FLORA: 0, ELEMENT.ERDA: 0} 
	for source in power_sources:
		if source.name != "Power_Source":
			continue
		
		var element = source.get_element()
		refined_power[element] += power_source_ratios.pop_front()
	return refined_power