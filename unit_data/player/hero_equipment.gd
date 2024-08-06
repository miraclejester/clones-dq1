extends RefCounted
class_name HeroEquipment

var eq_dict: Dictionary = {}

func get_attack_power() -> int:
	var w: EquipmentData = eq_dict.get(EquipmentData.EquipmentType.WEAPON) as EquipmentData
	if w != null:
		return w.attack_power
	else:
		return 0


func get_defense_power() -> int:
	var a: EquipmentData = eq_dict.get(EquipmentData.EquipmentType.ARMOR) as EquipmentData
	var s: EquipmentData = eq_dict.get(EquipmentData.EquipmentType.SHIELD) as EquipmentData
	var a_power: int = 0
	if a != null:
		a_power = a.defense_power
	var s_power: int = 0
	if s != null:
		s_power = s.defense_power
	return a_power + s_power


func equip(eq: EquipmentData) -> EquipmentData:
	var prev: EquipmentData = eq_dict.get(eq.equipment_type)
	eq_dict[eq.equipment_type] = eq
	return prev
