shader_type canvas_item;

float calcAlpha(float oldAlpha, vec2 uv, float time) {
	if (oldAlpha > 0.0) {
		return step(sin(uv.y*500.0)*sin(24.0*time)*(sin(uv.x*100.0)), 0);
	}
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	float oldAlpha = COLOR.a;
	float coordY = FRAGCOORD.y;
	float evenCoord = float(int(coordY) % 2);
	float newAlpha = calcAlpha(oldAlpha, UV, TIME);
	COLOR.a = newAlpha;
}