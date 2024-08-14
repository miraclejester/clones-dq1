extends UIMenu
class_name StatusWindow

@onready var hero_name: Label = %HeroName
@onready var strength: Label = %Strength
@onready var agility: Label = %Agility
@onready var max_hp: Label = %MaxHP
@onready var max_mp: Label = %MaxMP
@onready var attack_power: Label = %AttackPower
@onready var defense_power: Label = %DefensePower
@onready var weapon_name_line_1: Label = %WeaponNameLine1
@onready var weapon_name_line_2: Label = %WeaponNameLine2
@onready var armor_name_line_1: Label = %ArmorNameLine1
@onready var armor_name_line_2: Label = %ArmorNameLine2
@onready var shield_name_line_1: Label = %ShieldNameLine1
@onready var shield_name_line_2: Label = %ShieldNameLine2

var menu_active: bool = false

func _process(_delta: float) -> void:
	if not menu_active:
		return
	if Input.is_action_just_pressed("A") or Input.is_action_just_pressed("B"):
		cancelled.emit()


func activate() -> void:
	menu_active = true


func deactivate() -> void:
	menu_active = false


func set_data_from_hero(hero: HeroUnit) -> void:
	hero_name.text = "NAME:%s" % hero.get_unit_name()
	strength.text = "%d" % hero.stats.get_stat(UnitStats.StatKey.STR)
	agility.text = "%d" % hero.stats.get_stat(UnitStats.StatKey.AGI)
	max_hp.text = "%d" % hero.stats.get_base(UnitStats.StatKey.HP)
	max_mp.text = "%d" % hero.stats.get_base(UnitStats.StatKey.MP)
	attack_power.text = "%d" % hero.get_attack()
	defense_power.text = "%d" % hero.get_defense()
	set_equipment_name(
		hero.equipment.get_equip(EquipmentData.EquipmentType.WEAPON),
		weapon_name_line_1,
		weapon_name_line_2
	)
	set_equipment_name(
		hero.equipment.get_equip(EquipmentData.EquipmentType.ARMOR),
		armor_name_line_1,
		armor_name_line_2
	)
	set_equipment_name(
		hero.equipment.get_equip(EquipmentData.EquipmentType.SHIELD),
		shield_name_line_1,
		shield_name_line_2
	)


func set_equipment_name(equip: EquipmentData, first_line: Label, second_line: Label) -> void:
	var eq_name: String = ""
	if equip != null:
		eq_name = equip.item_name
	var eq_split: Array[String] = []
	eq_split.assign(eq_name.split(" "))
	if eq_split.size() > 1:
		first_line.text = eq_split[0]
		second_line.text = eq_split[1]
	else:
		first_line.text = eq_name
		second_line.text = ""
