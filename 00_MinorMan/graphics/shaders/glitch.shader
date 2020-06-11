shader_type canvas_item;

const int THICKNESS = 2;

uniform vec2 _ScanLineJitter; // (displacement, threshold)
uniform vec2 _VerticalJump;   // (amount, time)
uniform float _HorizontalShake;
uniform vec2 _ColorDrift;     // (amount, time)

float nrand(float x, float y)
{
	return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment()
{
	float u = SCREEN_UV.x;
	float v = SCREEN_UV.y;

	// Scan line jitter
	float jitter = nrand(v, TIME) * 2.0 - 1.0;
	jitter *= step(_ScanLineJitter.y, abs(jitter)) * _ScanLineJitter.x;

	// Vertical jump
	float jump = mix(v, fract(v + _VerticalJump.y), _VerticalJump.x);

	// Horizontal shake
	float shake = (nrand(TIME, 2) - 0.5) * _HorizontalShake;

	// Color drift
	float drift = sin(jump + _ColorDrift.y) * _ColorDrift.x;

	vec4 src1 = texture(SCREEN_TEXTURE, fract(vec2(u + jitter + shake, jump)));
	vec4 src2 = texture(SCREEN_TEXTURE, fract(vec2(u + jitter + shake + drift, jump)));
	
	// Sobel filter

	vec3 col2 = -8.0 * texture(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;

	col2 += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, SCREEN_PIXEL_SIZE.y) * float(THICKNESS)).xyz;
	col2 += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -SCREEN_PIXEL_SIZE.y) * float(THICKNESS)).xyz;
	col2 += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0) * float(THICKNESS)).xyz;
	col2 += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, 0.0) * float(THICKNESS)).xyz;
	col2 += texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE.xy * float(THICKNESS)).xyz;
	col2 += texture(SCREEN_TEXTURE, SCREEN_UV - SCREEN_PIXEL_SIZE.xy * float(THICKNESS)).xyz;
	col2 += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y) * float(THICKNESS)).xyz;
	col2 += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y) * float(THICKNESS)).xyz;
	
	float thresh_col2 = (col2.r + col2.g + col2.b) / 3.0;
	thresh_col2 = step(0.15, thresh_col2);
	col2 = vec3(thresh_col2);
	
	vec4 sobel_output = vec4(col2, 1.0);
	vec4 glitch_output = vec4(src1.r, src2.g, src1.b, 1.0);
	
	COLOR.rgb = glitch_output.rgb;// - sobel_output.rgb;
}

// PAINT FILTER 2

//const int _KernelSize = 16;
//
//vec4 calcRegion(ivec2 lower, ivec2 upper, int samples, vec2 uv, vec2 pix_size, sampler2D screen_tex)
//{
//	vec4 r;
//	vec3 sum = vec3(0.0);
//	vec3 squareSum = vec3(0.0);
//
//	for (int x = lower.x; x <= upper.x; ++x)
//	{
//		for (int y = lower.y; y <= upper.y; ++y)
//		{
//			vec2 offset = vec2(pix_size.x * float(x), pix_size.y * float(y));
//			vec3 tex = texture(screen_tex, uv + offset).rgb;
//			sum += tex;
//			squareSum += tex * tex;
//		}
//	}
//
//	r.rgb = sum / float(samples);
//	vec3 variance = abs((squareSum / float(samples)) - (r.rgb * r.rgb));
//	r.w = length(variance);
//
//	return r;
//}
//
//void fragment() //(v2f_img i) : SV_Target
//{
//	vec4 result1;
//
//	int upper = (_KernelSize - 1) / 2;
//	int lower = -upper;
//
//	int samples = (upper + 1) * (upper + 1);
//
//	// Calculate the four regional parameters as discussed.
//	vec4 regionA = calcRegion(ivec2(lower, lower), ivec2(0, 0), samples, SCREEN_UV, SCREEN_PIXEL_SIZE, SCREEN_TEXTURE);
//	vec4 regionB = calcRegion(ivec2(0, lower), ivec2(upper, 0), samples, SCREEN_UV, SCREEN_PIXEL_SIZE, SCREEN_TEXTURE);
//	vec4 regionC = calcRegion(ivec2(lower, 0), ivec2(0, upper), samples, SCREEN_UV, SCREEN_PIXEL_SIZE, SCREEN_TEXTURE);
//	vec4 regionD = calcRegion(ivec2(0, 0), ivec2(upper, upper), samples, SCREEN_UV, SCREEN_PIXEL_SIZE, SCREEN_TEXTURE);
//
//	vec3 col = regionA.rgb;
//	float minVar = regionA.w;
//
//	/*	Cascade through each region and compare variances - the end
//		result will be the that the correct mean is picked for col.
//	*/
//	float testVal;
//
//	testVal = step(regionB.w, minVar);
//	col = mix(col, regionB.rgb, testVal);
//	minVar = mix(minVar, regionB.w, testVal);
//
//	testVal = step(regionC.w, minVar);
//	col = mix(col, regionC.rgb, testVal);
//	minVar = mix(minVar, regionC.w, testVal);
//
//	testVal = step(regionD.w, minVar);
//	col = mix(col, regionD.rgb, testVal);
//
//	result1 = vec4(col, 1.0);

// PAINT FILTER 1

// const int radius = 3;
//
// void fragment()
// {
//	vec2 src_size = SCREEN_PIXEL_SIZE;
//	vec2 uv = SCREEN_UV;
//	float n = float((radius + 1) * (radius + 1));
//
//	vec3 m0 = vec3(0.0); vec3 m1 = vec3(0.0); vec3 m2 = vec3(0.0); vec3 m3 = vec3(0.0);
//	vec3 s0 = vec3(0.0); vec3 s1 = vec3(0.0); vec3 s2 = vec3(0.0); vec3 s3 = vec3(0.0);
//	vec3 c;
//
//	for (int j = -radius; j <= 0; ++j)  {
//		for (int i = -radius; i <= 0; ++i)  {
//			c = texture(SCREEN_TEXTURE, uv + vec2(float(i),float(j)) * src_size).rgb;
//			m0 += c;
//			s0 += c * c;
//		}
//	}
//
//	for (int j = -radius; j <= 0; ++j)  {
//		for (int i = 0; i <= radius; ++i)  {
//			c = texture(SCREEN_TEXTURE, uv + vec2(float(i),float(j)) * src_size).rgb;
//			m1 += c;
//			s1 += c * c;
//		}
//	}
//
//	for (int j = 0; j <= radius; ++j)  {
//		for (int i = 0; i <= radius; ++i)  {
//			c = texture(SCREEN_TEXTURE, uv + vec2(float(i),float(j)) * src_size).rgb;
//			m2 += c;
//			s2 += c * c;
//		}
//	}
//
//	for (int j = 0; j <= radius; ++j)  {
//		for (int i = -radius; i <= 0; ++i)  {
//			c = texture(SCREEN_TEXTURE, uv + vec2(float(i),float(j)) * src_size).rgb;
//			m3 += c;
//			s3 += c * c;
//		}
//	}
//
//
//	float min_sigma2 = 1e+2;
//	m0 /= n;
//	s0 = abs(s0 / n - m0 * m0);
//
//	float sigma2 = s0.r + s0.g + s0.b;
//	if (sigma2 < min_sigma2) {
//		min_sigma2 = sigma2;
//		COLOR = vec4(m0, 1.0);
//	}
//
//	m1 /= n;
//	s1 = abs(s1 / n - m1 * m1);
//
//	sigma2 = s1.r + s1.g + s1.b;
//	if (sigma2 < min_sigma2) {
//		min_sigma2 = sigma2;
//		COLOR = vec4(m1, 1.0);
//	}
//
//	m2 /= n;
//	s2 = abs(s2 / n - m2 * m2);
//
//	sigma2 = s2.r + s2.g + s2.b;
//	if (sigma2 < min_sigma2) {
//		min_sigma2 = sigma2;
//		COLOR = vec4(m2, 1.0);
//	}
//
//	m3 /= n;
//	s3 = abs(s3 / n - m3 * m3);
//
//	sigma2 = s3.r + s3.g + s3.b;
//	if (sigma2 < min_sigma2) {
//		min_sigma2 = sigma2;
//		COLOR = vec4(m3, 1.0);
//	}
//}

// SOBEL FILTER

//void fragment() {
//
//	COLOR = mix(result1, result2, 0.05);
//}