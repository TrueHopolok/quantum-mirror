shader_type canvas_item;

uniform bool onoff = true;
uniform vec4 color : source_color = vec4(1.0);
uniform int pixels_to_check = 1; 
uniform int center_distance_cap = 1;

bool has_neighbour(vec2 uv, vec2 texture_pixel_size, sampler2D sprite_texture) {
	for (int x = - pixels_to_check; x <= pixels_to_check; x++) {
		for (int y = - pixels_to_check; y <= pixels_to_check; y++) {
			if (x == 0 && y == 0) {
				continue;
			}
			
			if (abs(x) + abs(y) > center_distance_cap) {
				continue;
			}
			vec2 xy = vec2(float(x), float(y));
			vec2 coords = uv + xy * texture_pixel_size;
			if (texture(sprite_texture, coords).a > .0) {
				return true;
			}
		}
	}
	return false;
}

void fragment() {
	if (onoff && COLOR.a < .0001 && has_neighbour(UV, TEXTURE_PIXEL_SIZE, TEXTURE)) {
		COLOR = color;
	}
}