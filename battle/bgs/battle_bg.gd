extends CanvasGroup
class_name BattleBG

signal bg_appear_finished()

@onready var mask_piece: Sprite2D = $MaskPiece
@onready var bg: Sprite2D = $BG

var image: Image
var texture: ImageTexture

var anim_speed: float = 0.01
var cur_size: int = 1

func _ready() -> void:
	create_initial_texture()


func set_bg_texture(t: Texture2D) -> void:
	bg.texture = t


func start_appear_animation() -> void:
	show_block(3, 3)
	await show_outline(3, 3, 4)
	await show_outline(5, 4, 5)
	await show_outline(7, 5, 6)


func show_outline(size: int, start_x: int, start_y) -> void:
	var x = start_x
	var y = start_y
	show_block(x, y)
	await get_tree().create_timer(anim_speed).timeout
	for i in range(size - 2):
		x -= 1
		show_block(x, y)
		await get_tree().create_timer(anim_speed).timeout
	for i in range(size - 1):
		y -= 1
		show_block(x, y)
		await get_tree().create_timer(anim_speed).timeout
	for i in range(size - 1):
		x += 1
		show_block(x, y)
		await get_tree().create_timer(anim_speed).timeout
	for i in range(size - 1):
		y += 1
		show_block(x, y)
		await get_tree().create_timer(anim_speed).timeout


func create_initial_texture() -> void:
	image = Image.create(112, 112, false, Image.FORMAT_RGBA8)
	image.fill(Color(1, 1, 1, 0))
	texture = ImageTexture.create_from_image(image)
	mask_piece.texture = texture


func show_block(bx: int, by: int) -> void:
	image.fill_rect(Rect2i(bx * 16, by * 16, 16, 16), Color.WHITE)
	texture.set_image(image)
