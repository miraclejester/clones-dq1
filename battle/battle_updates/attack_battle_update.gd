extends BattleUpdate
class_name AttackBattleUpdate

enum AttackResult {
	DODGE,
	HIT,
	CRIT
}

var result: AttackResult
var attacker: BattleUnit
var defender: BattleUnit
var damage: int

static func fromData(r: AttackResult, a: BattleUnit, def: BattleUnit, dmg: int) -> AttackBattleUpdate:
	var res: AttackBattleUpdate = AttackBattleUpdate.new()
	res.result = r
	res.attacker = a
	res.defender = def
	res.damage = dmg
	return res
