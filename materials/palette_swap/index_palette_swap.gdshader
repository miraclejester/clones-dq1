shader_type canvas_item;

uniform sampler2D palette : filter_nearest;
uniform int color_index;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	ivec3 colori = ivec3(round(original_color.rgb * 255.0));
	ivec2 color_count = textureSize(palette, 0);
	float idx = -1.0;
	
	for (int i = 0; i < color_count.x; ++i) {
		vec3 color2 = texture(palette, vec2(float(i) / float(color_count.x - 1), 0)).rgb;
		ivec3 colori2 = ivec3(round(color2 * 255.0));
		
		if (colori == colori2) {
			idx = float(i);
			break;
		}
	}
	
	if (idx >= 0.0) {
		vec2 uv;
		uv.x = idx / float(color_count.x - 1);
		uv.y = float(color_index) / float(color_count.y);
		vec4 palette_color = texture(palette, uv);
		COLOR = vec4(palette_color.rgb, original_color.a);
	} else {
		COLOR = original_color;
	}
}
