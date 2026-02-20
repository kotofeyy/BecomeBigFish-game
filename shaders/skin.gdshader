shader_type canvas_item;

uniform bool is_active = true;
uniform vec4 target_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); 	// Какой цвет ищем (черный)
uniform vec4 replace_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); 	// На какой меняем (например, красный)
uniform float precision : hint_range(0.0, 1.0) = 0.01;              	// Точность совпадения

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    
    // Если активен и цвет пикселя похож на целевой (с учетом прозрачности)
    if (is_active && distance(current_color.rgba, target_color.rgba) < precision) {
        COLOR = replace_color;
    } else {
        COLOR = current_color;
    }
}

