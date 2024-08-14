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


func get_damage_multiplier(key: UnitStats.DamageType) -> float:
	var base: float = 1.0
	for eq in eq_dict.values():
		var e: EquipmentData = eq as EquipmentData
		for multiplier in e.damage_multipliers:
			var m: DamageModifierData = multiplier as DamageModifierData
			if m.damage_type == key:
				base *= m.modifier
	return base


func get_resistance_multiplier(key: UnitStats.ResistanceKey) -> float:
	var base: float = 1.0
	for eq in eq_dict.values():
		var e: EquipmentData = eq as EquipmentData
		for m in e.resistance_modifiers:
			if m.resistance_type == key:
				base *= m.modifier
	return base


func get_base_resistance(key: UnitStats.ResistanceKey) -> float:
	var base: float = -1.0
	for eq in eq_dict.values():
		var e: EquipmentData = eq as EquipmentData
		for m in e.resistance_modifiers:
			if m.resistance_type == key:
				base = max(base, m.base)
	return base


func generate_save_data() -> Array[int]:
	var res: Array[int] = []
	for val in eq_dict.values():
		var v: EquipmentData = val as EquipmentData
		res.append(v.item_id)
	return res


func load_from_data(data: Array[int]) -> void:
	for id in data:
		equip(GameDataManager.get_item(id) as EquipmentData)


func get_equip(key: EquipmentData.EquipmentType) -> EquipmentData:
	return eq_dict.get(key)
