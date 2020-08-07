shader_type spatial;

uniform sampler2D viewport;
render_mode unshaded;

void vertex() {
}

void fragment() {
	vec3 color = vec3(texture(viewport, SCREEN_UV).x, texture(viewport, SCREEN_UV).y, texture(viewport, SCREEN_UV).z);
    ALBEDO = color;
}