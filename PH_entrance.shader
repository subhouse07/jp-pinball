shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.r = 0.5 + sin(UV.y) * sin(8.0*TIME);
	COLOR.g -= 0.5 + cos(UV.y) * sin(7.0*TIME);
//	kCOLOR.rgb = vec3(COLOR.r - sin(pow(3.14, 1.6)*TIME), COLOR.g - (0.7 + sin(pow(3.14, 1.5)*TIME)), COLOR.b - (0.2 + sin(TIME*3.14)));
}

void vertex() {
	float rate = 2.0;
	float dist = 5.0;
	float old_x = VERTEX.x;
  VERTEX.x /= 1.0-sin(TIME*rate)*0.2 / 1.0/sin(pow(VERTEX.y, 3.0));
VERTEX.y /= 1.0-sin(TIME*rate-1.0)*0.2 / 1.0/sin(pow(old_x,3.0));
}