extends Resource
class_name EncounterChanceEntry

enum TileBattleID {
	GRASSLANDS = 1, BRIDGE, FOREST, HILLS, DESERT,
	SWAMP, STAIRS, CHEST, BARRIER, BRICK
}

@export var battle_id: TileBattleID
@export var chance: float
