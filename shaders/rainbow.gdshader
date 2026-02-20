shader_type canvas_item;

uniform bool is_active = true;
uniform bool is_rainbow = false;
uniform float speed : hint_range(0.0, 10.0) = 1.0;
uniform float precision : hint_range(0.0, 0.1) = 0.05; // Допуск (на случай, если черный не идеально чистый)
uniform vec4 replace_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); 

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    // Проверяем, является ли текущий пиксель черным (RGB близки к 0)
    // distance сравнивает цвет пикселя с черным цветом vec3(0.0)
    if (is_active && distance(color.rgb, vec3(0.0)) < precision && color.a > 0.1) {
		if (is_rainbow ){
			float t = TIME * speed;
	        color.rgb = vec3(
	            0.5 + 0.5 * cos(t),
	            0.5 + 0.5 * cos(t + 2.094),
	            0.5 + 0.5 * cos(t + 4.188)
	        );
		}
		else {
			color = replace_color;
		}
       
    }
    
    COLOR = color;
}
