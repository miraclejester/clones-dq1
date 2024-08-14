extends Control
class_name FileDataDisplay

@onready var hero_name: Label = %HeroName
@onready var level: Label = %Level


func set_data(h_name: String, l: int) -> void:
	hero_name.text = h_name
	level.text = "LEVEL   %d" % l
