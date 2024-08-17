extends RefCounted
class_name HeroEquipment

signal item_equipped(item: EquipmentData)

var eq_dict: Dictionary = {}
var accessories: Array[int] = []
var permanent_defense_modifier: int = 0

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
	return a_power + s_power + permanent_defense_modifier


func equip(eq: EquipmentData) -> EquipmentData:
	var prev: EquipmentData = eq_dict.get(eq.equipment_type)
	eq_dict[eq.equipment_type] = eq
	item_equipped.emit(eq)
	return prev


func equip_accessory(item_id: int) -> void:
	if not accessories.has(item_id):
		accessories.append(item_id)


func is_accessory_equipped(item_id: int) -> bool:
	return accessories.has(item_id)


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


func generate_save_data() -> Dictionary:
	var res: Dictionary = {}
	
	var equips: Array[int] = []
	for val in eq_dict.values():
		var v: EquipmentData = val as EquipmentData
		equips.append(v.item_id)
	res["equips"] = equips
	res["accessories"] = accessories
	res["defense_modifier"] = permanent_defense_modifier
	return res


func load_from_data(data: Dictionary) -> void:
	for id in data.get("equips", []):
		equip(GameDataManager.get_item(id) as EquipmentData)
	for id in data.get("accessories", []):
		equip_accessory(id)
	permanent_defense_modifier = data.get("defense_modifier", 0)


func get_equip(key: EquipmentData.EquipmentType) -> EquipmentData:
	return eq_dict.get(key)


func has_equip(key: EquipmentData.EquipmentType) -> bool:
	return eq_dict.has(key)
