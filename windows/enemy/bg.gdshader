/*shader_type canvas_item;

uniform vec2 point = vec2(150.0, 150.0);
uniform vec2 pos = vec2(0.0, 0.0);
uniform vec4 modulate2 = vec4(0.5, 0, 0.008, 1.0);

vec2 rotateUV(vec2 uv, float rotation, vec2 mid)
{
	return vec2(
		cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
		cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
	);
}

varying flat vec4 modulate;
void vertex() {
	modulate = COLOR;
}

vec4 HexCoords(vec2 uv) {
	vec2 r = vec2(1, 1.73);
	vec2 h = r*.5;
	
	vec2 a = mod(uv, r)-h;
	vec2 b = mod(uv-h, r)-h;
	
	vec2 gv = dot(a, a) < dot(b,b) ? a : b;
	
	gv += 0.5;
	
	vec2 id = uv-gv;
	return vec4(gv.x, gv.y, id.x,id.y);
}

void fragment() {
	vec2 spx = SCREEN_UV/SCREEN_PIXEL_SIZE;
	spx += pos;
	vec2 uv = spx * TEXTURE_PIXEL_SIZE;
	
	vec2 pushPoint = rotateUV(point+pos, -0.23, vec2(0.0));
	//vec2 pushPoint = point;
	
	float scale = 1.0;
	
	vec4 testCol = vec4(0.0);
	vec4 col = vec4(0.0);
	
	uv = rotateUV(uv, -0.23, vec2(0.0));
	
	for(int i=0; i<7; i++){
		vec2 idOff = vec2(cos(float(i)/6.0*TAU), sin(float(i)/6.0*TAU));
		if(i==6){
			idOff = vec2(0.0);
		}
		vec2 luv = uv;
		float lscale = scale;
		
		vec4 coords2 = HexCoords(luv);
		coords2.xy -= idOff;
		coords2.zw += idOff;
		
		vec2 offset = vec2(0.0);
		vec2 diff = pushPoint - (coords2.zw+0.5)/TEXTURE_PIXEL_SIZE;
		float d = length(diff)/240.0;
		//d = pow(max(0.0,1.0-d), 1.5)*(1.0-1.0/(20.0*d+1.0));
		float d2 = 1.0/(d+1.0);
		float d3 = d2*(1.0-1.0/(10.0*d+1.0));
		float d4 = 1.0/(pow(2.0,pow(400.0*d,0.45)-9.0)+1.0);
		//float d2 = distance((luv)/TEXTURE_PIXEL_SIZE, pushPoint);
		//if(d2 < 10.0){
			//testCol += vec4(0.0,1.0,0.0,1.0);
		//}
		
		offset += 1.1*normalize(diff)*max(0.0, d3);
		
		lscale *= 1.0-1.0*d4;
		//lscale *= 0.8+0.5*d2*d2;
		
		luv = coords2.xy + offset;
		luv = (luv-0.5)*(1.0/lscale) + 0.5;
		
		vec4 c = texture(TEXTURE, luv)*mix(modulate2, modulate, clamp(1.6*d,0.0,1.0))*clamp(2.0*d,0.0,1.0);
		//if(i!=6){
			//c.r = (0.0);
		//}
		if(c.a > col.a){
			col = c/1.0;
		}
	}
	//col /= 3.0;
	
	COLOR = testCol + col*0.9;
}
*/




shader_type canvas_item;

uniform vec2 point = vec2(150.0, 150.0);
uniform vec2 pos = vec2(0.0, 0.0);
uniform vec4 modulate2 = vec4(0.5, 0, 0.008, 1.0);

vec2 rotateUV(vec2 uv, float rotation, vec2 mid)
{
	return vec2(
		cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
		cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
	);
}

varying flat vec4 modulate;
void vertex() {
	modulate = COLOR;
}

vec4 HexCoords(vec2 uv) {
	vec2 r = vec2(1, 1.73);
	vec2 h = r*.5;
	
	vec2 a = mod(uv, r)-h;
	vec2 b = mod(uv-h, r)-h;
	
	vec2 gv = dot(a, a) < dot(b,b) ? a : b;
	
	gv += 0.5;
	
	vec2 id = uv-gv;
	return vec4(gv.x, gv.y, id.x,id.y);
}

void fragment() {
	vec2 spx = (SCREEN_UV/SCREEN_PIXEL_SIZE);
	spx += pos;
	vec2 uv = spx * TEXTURE_PIXEL_SIZE*vec2(1, 1);
	
	vec2 pushPoint = rotateUV(point+pos, -0.23, vec2(0.0));
	//vec2 pushPoint = point;
	
	float scale = 1.0;
	
	vec4 col = vec4(0.0, 0.0, 0.0, 0.0);
	
	uv = rotateUV(uv, -0.23, vec2(0.0));
	
	for(int i=0; i<7; i++){
		vec2 idOff = vec2(cos(float(i)/6.0*TAU), sin(float(i)/6.0*TAU));
		if(i==6){
			idOff = vec2(0.0);
		}
		vec2 luv = uv;
		float lscale = scale;
		
		vec4 coords2 = HexCoords(luv);
		coords2.xy -= idOff;
		coords2.zw += idOff;
		
		vec2 offset = vec2(0.0);
		vec2 diff = pushPoint - (coords2.zw+0.5)/TEXTURE_PIXEL_SIZE;
		float d = length(diff)/240.0;
		//d = pow(max(0.0,1.0-d), 1.5)*(1.0-1.0/(20.0*d+1.0));
		float d2 = 1.0/(d+1.0);
		float d3 = d2*(1.0-1.0/(10.0*d+1.0));
		float d4 = 1.0/(pow(2.0,pow(400.0*d,0.45)-9.0)+1.0);
		//float d2 = distance((luv)/TEXTURE_PIXEL_SIZE, pushPoint);
		//if(d2 < 10.0){
			//testCol += vec4(0.0,1.0,0.0,1.0);
		//}
		
		offset += 1.1*normalize(diff)*max(0.0, d3);
		
		lscale *= 1.0-1.0*d4;
		//lscale *= 0.8+0.5*d2*d2;
		
		luv = coords2.xy + offset;
		luv = (luv-0.5)*(1.0/lscale) + 0.5;
		
		vec4 c = texture(TEXTURE, luv);
		
		vec4 m = mix(modulate2, modulate, clamp(1.35-0.22*pow(d,2.0), 0.0, 1.0));
		c *= mix(0.7*vec4(0.247, 0.278, 0.318, 1.0), m, clamp(1.0-0.4*pow(d, 1.0), 0.0, 1.0));
		//if(i!=6){
			//c.r = (0.0);
		//}
		if(c.a > col.a){
			col = c/1.0;
		}
	}
	
	//col /= 3.0;
	
	//COLOR = col;
	COLOR = mix(vec4(0.0,0.0,0.0,0.0), vec4(col.rgb,1.0), col.a);
}

