shader_type canvas_item;
render_mode unshaded;

// Based on https://github.com/GDQuest/godot-demos/blob/master/2018/09-20-shaders/shaders/outline.shader

uniform float width : hint_range(0.0, 16.0);
uniform vec4 outline_color : hint_color;

void fragment() {

    float size = width / 32.0;
    vec4 sprite_color = texture(TEXTURE, UV);

    float alpha = sprite_color.a;
    alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;
    alpha += texture(TEXTURE, UV + vec2(size, -size)).a;
    alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(size, size)).a;
    alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
    alpha += texture(TEXTURE, UV + vec2(-size, size)).a;
    alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(-size, -size)).a;

    vec3 final_color = mix(outline_color.rgb, sprite_color.rgb, sprite_color.a);
    COLOR = vec4(final_color, clamp(alpha, 0.0, 1.0));
}