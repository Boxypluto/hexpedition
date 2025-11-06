shader_type canvas_item;

uniform bool active = false;

void fragment() {
	if(active) {
		COLOR.rgb = vec3(1.0);
	}
}
