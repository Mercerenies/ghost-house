shader_type canvas_item;
render_mode unshaded;

// 0.0 No change, 1.0 completely gray
uniform float desaturate_amount : hint_range(0.0, 3.0);

void fragment() {

    vec4 fg_color = texture(TEXTURE, UV);
    vec4 bg_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    vec4 color = fg_color * fg_color.a + bg_color * bg_color.a * (1.0 - fg_color.a);
    float grey = color.r * 0.3 + color.g * 0.6 + color.b + 0.1;

    float interp = clamp(desaturate_amount * fg_color.a, 0.0, 1.0);
    vec3 final_color = mix(color.rgb, vec3(grey), interp);
    COLOR = vec4(final_color.rgb, 1.0);
}