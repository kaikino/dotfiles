// ══════════════════════════════════════════════════════════════════════
//  CRT, restrained. Scanlines you feel more than see, a soft phosphor
//  bloom on bright glyphs, and a vignette that pulls the eye inward.
//  No curvature, no chromatic aberration: those cost legibility and
//  this is a terminal you read all day.
//
//  Tune the four constants; Ghostty reloads on `cmux reload-config`.
// ══════════════════════════════════════════════════════════════════════

const float SCANLINE_STRENGTH = 0.10;  // 0 = off, 0.25 = obvious
const float SCANLINE_PERIOD   = 4.0;   // physical px per line (Retina = 2 logical)
const float BLOOM_STRENGTH    = 0.12;  // glow bleeding off bright pixels
const float VIGNETTE_STRENGTH = 0.16;  // edge darkening, 0 = flat

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv  = fragCoord / iResolution.xy;
    vec4 src = texture(iChannel0, uv);
    vec3 col = src.rgb;

    // Bloom: cheap 4-tap cross blur, added back weighted by brightness
    // so navy background stays flat and only glyphs glow.
    vec2 px = 1.0 / iResolution.xy;
    vec3 blur = texture(iChannel0, uv + vec2( px.x, 0.0)).rgb
              + texture(iChannel0, uv + vec2(-px.x, 0.0)).rgb
              + texture(iChannel0, uv + vec2(0.0,  px.y)).rgb
              + texture(iChannel0, uv + vec2(0.0, -px.y)).rgb;
    blur *= 0.25;
    float lum = dot(blur, vec3(0.299, 0.587, 0.114));
    col += blur * lum * BLOOM_STRENGTH;

    // Scanlines: a soft sine so there's no hard banding on Retina.
    float scan = 0.5 + 0.5 * sin(fragCoord.y * 6.28318 / SCANLINE_PERIOD);
    col *= 1.0 - SCANLINE_STRENGTH * scan;

    // Vignette: 1.0 at centre, falls off toward corners.
    vec2 v = uv * (1.0 - uv);
    float vig = pow(clamp(v.x * v.y * 16.0, 0.0, 1.0), VIGNETTE_STRENGTH);
    col *= vig;

    // Keep the alpha the terminal handed us so window transparency
    // still works — the shader must not paint over the blur.
    fragColor = vec4(col, src.a);
}
