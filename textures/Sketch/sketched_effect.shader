shader_type canvas_item;

uniform sampler2D shaded;
uniform float saturation = 0.2f;
uniform float shading = 0.6f;
uniform float shimmering = 1f;

void fragment() {
	vec3 original_color = texture(TEXTURE, UV).xyz;
	
    /*vec3 borderlines = -8.0 * original_color;
    borderlines += texture(TEXTURE, SCREEN_UV + vec2(0.0, SCREEN_PIXEL_SIZE.y)).xyz;
    borderlines += texture(TEXTURE, SCREEN_UV + vec2(0.0, -SCREEN_PIXEL_SIZE.y)).xyz;
    borderlines += texture(TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0)).xyz;
    borderlines += texture(TEXTURE, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, 0.0)).xyz;
    borderlines += texture(TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE.xy).xyz;
    borderlines += texture(TEXTURE, SCREEN_UV - SCREEN_PIXEL_SIZE.xy).xyz;
    borderlines += texture(TEXTURE, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)).xyz;
    borderlines += texture(TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y)).xyz;*/
	//borderlines = vec3(1,1,1) - borderlines;
	
	vec3 sketchcolor = original_color;
	
	float timesteps = ceil(TIME*shimmering)/shimmering*10.;
	vec2 sketchUV = UV + vec2(timesteps/9.7465, timesteps*1.15735);
	
	float alpha = (1.-texture(shaded, sketchUV - floor(sketchUV)).x);
	alpha *= 1.-(original_color.x + original_color.y + original_color.z)/3.;
	sketchcolor = sketchcolor * alpha;
	
	COLOR.xyz = sketchcolor * shading + (1.-alpha) * original_color * saturation + (1.-alpha) * (1.-saturation) * vec3(1,1,1);
}