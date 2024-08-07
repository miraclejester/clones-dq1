extends Resource
class_name SFXEntry

enum SFXKey {
	Attack, EnemyAttack, Breathing
}

@export var key: SFXKey
@export var sfx: AudioStream
