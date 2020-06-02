shader_type canvas_item;

float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) - 0.5;
}

void vertex(){
	VERTEX += rand(VERTEX + floor(TIME * 3.0) ) * 3.0;
}