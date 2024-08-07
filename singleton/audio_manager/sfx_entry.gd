extends Resource
class_name SFXEntry

enum SFXKey {
	Attack, EnemyAttack, Breathing,
	ExcellentMove, Hit, Miss1,
	Miss2, ReceiveDamage, Spell,
	Run, MenuBlip
}

@export var key: SFXKey
@export var sfx: AudioStream
