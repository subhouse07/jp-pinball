shader_type canvas_item;

uniform lowp float DISTMAX = 0.05;
uniform lowp float INTERP = 0.025;

uniform lowp float yOffset = 0.0;
uniform vec2 objPos;
uniform vec2 spriteDim;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR.a > 0.0) {
		vec2 offsetObjPos = vec2(objPos.x, objPos.y - yOffset);
		vec2 objUV = offsetObjPos / spriteDim;
		float yScale = spriteDim.y / spriteDim.x;
		vec2 scaleUV = vec2(UV.x, UV.y*yScale);
		objUV.y = objUV.y * yScale;
		COLOR.a = smoothstep(DISTMAX, DISTMAX + INTERP, distance(scaleUV, objUV));
	}
}