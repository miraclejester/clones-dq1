extends Sprite2D
class_name DarknessLayer

var image: Image
var cur_strength: int = 0
var center_coord: Vector2i = Vector2i(8, 7)
var battery_stack: Array[int] = []

func _ready() -> void:
	initialize()


func initialize() -> void:
	create_initial_texture()
	illuminate(0)
	battery_stack = []


func create_initial_texture() -> void:
	image = Image.create(256+8, 224+8, false, Image.FORMAT_RGBA8)
	image.fill(Color.BLACK)
	texture = ImageTexture.create_from_image(image)


func illuminate(strength: int, battery: int = 0) -> void:
	cur_strength = strength
	var x: int = center_coord.x - strength
	var y: int = center_coord.y - strength
	show_block(x, y, 1 + strength * 2)
	if battery > 0:
		battery_stack.push_front(battery)


func on_step() -> void:
	if battery_stack.size() > 0:
		battery_stack[0] -= 1
		if battery_stack[0] <= 0:
			darken()
			battery_stack.pop_front()


func darken() -> void:
	cur_strength = clampi(cur_strength - 1, 0, 5)
	create_initial_texture()
	illuminate(cur_strength)


func show_block(bx: int, by: int, s: int) -> void:
	image.fill_rect(Rect2i(bx * 16 - 4, by * 16 - 4, 16*s, 16*s), Color.TRANSPARENT)
	texture.set_image(image)
