shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
    float avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
    COLOR.rgb = vec3(0.2);
	float alph = COLOR.a;
	COLOR.a = min(alph, 0.6);
}

void vertex() {
	float squash = VERTEX.y * 0.66;
	VERTEX.y = squash;
}