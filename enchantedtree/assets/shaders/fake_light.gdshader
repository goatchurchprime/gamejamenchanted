// Author: Jonathan T. - RakuNana
// Link: https://github.com/RakuNana/Shader-as-Light
// NOTE: Shader automatically converted from Godot Engine 4.4.dev7's StandardMaterial3D.

shader_type spatial;
render_mode alpha_to_coverage, blend_mix, cull_back, specular_toon, depth_draw_always;

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform bool useAlpha;
uniform bool useEmission;

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform sampler2D texture_heightmap : hint_default_black, filter_linear_mipmap, repeat_enable;
uniform float heightmap_scale : hint_range(-16.0, 16.0, 0.001);
uniform vec2 heightmap_flip;
uniform int heightmap_min_layers : hint_range(1, 64);
uniform int heightmap_max_layers : hint_range(1, 64);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

//added
//size of influence of the object
uniform float light_size = 5.0;
//Can create a global shader in project settings, then place global in front of var
uniform vec3 light_pos;
//objects position in the world
varying vec3 obj_pos;
uniform sampler2D reflection_map : hint_default_white;
uniform vec4 reflection_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float reflection_strength = 0.5;
uniform float specular_strength : hint_range(0.0, 1.0) = 0.0;
uniform float metallic_strength : hint_range(0.0, 1.0) = 0.0;
uniform float roughness_value : hint_range(0.0, 1.0) = 1.0;

// UV variables for controlling reflection map movement and scale
uniform vec2 reflection_offset = vec2(0.0, 0.0);
uniform vec2 reflection_scale = vec2(1.0, 1.0);

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	//added
	obj_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

}

void fragment() {
	vec2 base_uv = UV;

	//{
	//	// Height: Enabled
	//	vec3 view_dir = normalize(normalize(-VERTEX + EYE_OFFSET) * mat3(TANGENT * heightmap_flip.x, -BINORMAL * heightmap_flip.y, NORMAL));
	//	float depth = 1.0 - texture(texture_heightmap, base_uv).r;
	//	vec2 ofs = base_uv - view_dir.xy * depth * heightmap_scale * 0.01;
	//	base_uv = ofs;
	//}

	vec4 diffuse = texture(texture_albedo, base_uv);
    // Calculate reflection UV coordinates
    vec3 view_normal = normalize(VIEW * NORMAL);
    vec2 reflection_uv = vec2(
        view_normal.x * 0.5 + 0.5,
        view_normal.y * 0.5 + 0.5
    );

    // Apply reflection scale and offset
    reflection_uv = reflection_uv * reflection_scale + reflection_offset;

    // Sample the reflection map
    vec4 reflection = texture(reflection_map, reflection_uv);
	// Vertex Color Use as Albedo: Enabled
	//If you have vertex colors active , you need to use COLOR
	//albedo_tex *= COLOR;

	//added
	float min_dis = min(length(light_pos - obj_pos), light_size);

	//added, clamps the light influence. Light/Dark balanced
	float light_color =  clamp(light_size / 1.5 - min_dis,0.1,5.0) * 5.0;
	//mix the color , texture, and light together

	//flicker
	light_color *= sin(TIME * 15.0) * 0.025 + 0.5;
    // Combine diffuse and reflection
   // vec3 final_color = mix(
    //    diffuse.rgb,
    //    diffuse.a + reflection.rgb * reflection_color.rgb,
    //    reflection.r * reflection_strength
    //);
	ALBEDO = diffuse.rgb * diffuse.a * light_color;
	if (useAlpha)
	ALPHA *= diffuse.a * diffuse.a;//multiplying by light color gives a interesting ghosting effect * light_color;
	if (useEmission)
	EMISSION = diffuse.rgb  * light_color* (1.0 - diffuse.a);
	
	//float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	//METALLIC = metallic_tex * metallic;
	//SPECULAR = specular;

	//vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	//float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	//ROUGHNESS = roughness_tex * roughness;

	//Optional, adds a flickering effect to fake light
	//final_color *= sin(TIME * 10.0) * 0.5 + 0.5;
}