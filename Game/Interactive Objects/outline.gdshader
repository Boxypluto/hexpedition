shader_type canvas_item;

uniform bool active = false;
uniform vec4 outline_color: source_color;
const vec2[4] directions = {vec2(1.0, 0.0), vec2(-1.0, 0.0), vec2(0.0, 1.0), vec2(0.0, -1.0)};

void fragment() {
	if (active && COLOR.a != 1.0) {
		for(int i = 0; i < 4; i++) {
			vec2 direction = directions[i] * 2.0;
			if(texture(TEXTURE, UV + (direction * TEXTURE_PIXEL_SIZE)).a != 0.0) {
				COLOR = outline_color;
				break;
			}
		}
		for(int i = 0; i < 4; i++) {
			vec2 direction = directions[i] * 1.0;
			if(texture(TEXTURE, UV + (direction * TEXTURE_PIXEL_SIZE)).a != 0.0) {
				COLOR = vec4(1.0);
				break;
			}
		}
	}
}