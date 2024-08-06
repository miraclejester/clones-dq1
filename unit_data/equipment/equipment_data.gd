extends ItemData
class_name EquipmentData

enum EquipmentType {
	WEAPON, ARMOR, SHIELD
}

@export var equipment_type: EquipmentType
@export var attack_power: int
@export var defense_power: int
