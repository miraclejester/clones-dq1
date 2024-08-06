shader_type canvas_item;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	float c_linear = 0.2126*original_color.r + 0.7152*original_color.g + 0.0722*original_color.b;
	COLOR = vec4(c_linear, c_linear, c_linear, original_color.a);
}
