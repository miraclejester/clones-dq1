shader_type canvas_item;

uniform vec4 highlight_color : source_color;
uniform vec4 highlight_replace : source_color;
uniform vec4 general_replace : source_color;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	if (original_color.rgb == highlight_color.rgb) {
		COLOR = highlight_replace;
	} else if (original_color.rgb == vec3(0.0)) {
		COLOR = original_color;
	} else {
		COLOR = general_replace;
	}
}
