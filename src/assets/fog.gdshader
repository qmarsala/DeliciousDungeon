shader_type canvas_item;

uniform float radius = .15;
uniform vec2 origin = vec2(0.5, 0.5);
uniform vec3 color: source_color;

void fragment() {
    COLOR.rgb = color;
    float distance_to_center = distance(UV, origin);
	COLOR.a = clamp(distance_to_center / radius, 0, 1);
}