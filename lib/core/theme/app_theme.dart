import 'package:material_ui/material_ui.dart'
    show
        CardThemeData,
        Color,
        ColorScheme,
        Colors,
        ThemeData,
        EdgeInsets,
        BorderRadius,
        RoundedRectangleBorder,
        Brightness;

abstract final class AppTheme {
  static ThemeData light({Color seed = Colors.indigo}) {
    final base = ThemeData.light(useMaterial3: true);
    final scheme = ColorScheme.fromSeed(seedColor: seed);

    return base.copyWith(
      colorScheme: scheme,

      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        shadowColor: Colors.black.withOpacity(0.08),
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
        decorationColor: scheme.onSurface,
      ),
      primaryTextTheme: base.primaryTextTheme.apply(
        bodyColor: scheme.onPrimary,
        displayColor: scheme.onPrimary,
      ),
    );
  }

  static ThemeData dark({Color seed = Colors.indigo}) {
    final base = ThemeData.dark(useMaterial3: true);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      colorScheme: scheme,

      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        shadowColor: Colors.black.withOpacity(0.25),
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
        decorationColor: scheme.onSurface,
      ),
      primaryTextTheme: base.primaryTextTheme.apply(
        bodyColor: scheme.onPrimary,
        displayColor: scheme.onPrimary,
      ),
    );
  }
}

// Must condition is add splashFactory ==[ and it will read to WARNING: Falling back to CPU-only rendering. Reason: failed to create GrContext.
// Shader compilation error
// ------------------------
//    1    #version 300 es
//    2
//    3    precision mediump float;
//    4    precision mediump sampler2D;
//    5    out mediump vec4 sk_FragColor;
//    6    in mediump vec4 vcolor_S0;
//    7    in highp vec2 varccoord_S0;
//    8    void main() {
//    9    mediump vec4 outputColor_S0 = vcolor_S0;
//   10    highp float x_plus_1 = varccoord_S0.x;
//   11    highp float y = varccoord_S0.y;
//   12    mediump float coverage;
//   13    if (0.0 == x_plus_1) {
//   14    coverage = y;
//   15    } else {
//   16    highp float fn = x_plus_1 * (x_plus_1 - 2.0);
//   17    fn = ((y) * (y) + (fn));
//   18    highp float fnwidth = fwidth(fn);
//   19    coverage = 0.5 - fn / fnwidth;
//   20    coverage = clamp(coverage, 0.0, 1.0);
//   21    }
//   22    mediump vec4 outputCoverage_S0 = vec4(coverage);
//   23    {
//   24    sk_FragColor = outputColor_S0 * outputCoverage_S0;
//   25    }
//   26    }
//   27
// Errors:
// (unknown error)
// Shader compilation error
// ------------------------
//    1    #version 300 es
//    2
//    3    precision mediump float;
//    4    precision mediump sampler2D;
//    5    out mediump vec4 sk_FragColor;
//    6    in mediump vec4 vcolor_S0;
//    7    in highp vec2 varccoord_S0;
//    8    void main() {
//    9    mediump vec4 outputColor_S0 = vcolor_S0;
//   10    highp float x_plus_1 = varccoord_S0.x;
//   11    highp float y = varccoord_S0.y;
//   12    mediump float coverage;
//   13    if (0.0 == x_plus_1) {
//   14    coverage = y;
//   15    } else {
//   16    highp float fn = x_plus_1 * (x_plus_1 - 2.0);
//   17    fn = ((y) * (y) + (fn));
//   18    highp float fnwidth = fwidth(fn);
//   19    coverage = 0.5 - fn / fnwidth;
//   20    coverage = clamp(coverage, 0.0, 1.0);
//   21    }
//   22    mediump vec4 outputCoverage_S0 = vec4(coverage);
//   23    {
//   24    sk_FragColor = outputColor_S0 * outputCoverage_S0;
//   25    }
//   26    }
//   27
// Errors:
// (unknown error)
// Shader compilation error
// ------------------------
//    1    #version 300 es
//    2
//    3    precision mediump float;
//    4    precision mediump sampler2D;
//    5    out mediump vec4 sk_FragColor;
//    6    in mediump vec4 vcolor_S0;
//    7    void main() {
//    8    mediump vec4 outputColor_S0 = vcolor_S0;
//    9    {
//   10    sk_FragColor = outputColor_S0;
//   11    }
//   12    }
//   13
// Errors:
// (unknown error)
// Shader compilation error
// ------------------------
//    1    #version 300 es
//    2
//    3    precision mediump float;
//    4    precision mediump sampler2D;
//    5    out mediump vec4 sk_FragColor;
//    6    uniform highp mat3 umatrix_S1_c0_c0_c0_c0;
//    7    uniform highp vec4 urect_S1_c0_c0_c0;
//    8    uniform highp mat3 umatrix_S1_c0;
//    9    uniform sampler2D uTextureSampler_0_S1;
//   10    in mediump vec4 vcolor_S0;
//   11    in highp vec2 vTransformedCoords_3_S0;
//   12    void main() {
//   13    mediump vec4 outputColor_S0 = vcolor_S0;
//   14    highp vec2 _16_tmp_1_coords = vTransformedCoords_3_S0;
//   15    mediump float _17_xCoverage;
//   16    mediump float _18_yCoverage;
//   17    {
//   18    mediump vec4 _19_rect = vec4(urect_S1_c0_c0_c0.xy - _16_tmp_1_coords, _16_tmp_1_coords -
//   urect_S1_c0_c0_c0.zw);
//   19    _17_xCoverage = (1.0 - texture(uTextureSampler_0_S1, mat3x2(umatrix_S1_c0_c0_c0_c0) *
//   vec3(vec2(_19_rect.x, 0.5), 1.0), -0.475).x) - texture(uTextureSampler_0_S1,
//   mat3x2(umatrix_S1_c0_c0_c0_c0) * vec3(vec2(_19_rect.z, 0.5), 1.0), -0.475).x;
//   20    _18_yCoverage = (1.0 - texture(uTextureSampler_0_S1, mat3x2(umatrix_S1_c0_c0_c0_c0) *
//   vec3(vec2(_19_rect.y, 0.5), 1.0), -0.475).x) - texture(uTextureSampler_0_S1,
//   mat3x2(umatrix_S1_c0_c0_c0_c0) * vec3(vec2(_19_rect.w, 0.5), 1.0), -0.475).x;
//   21    }
//   22    mediump vec4 output_S1 = vec4(_17_xCoverage * _18_yCoverage);
//   23    {
//   24    sk_FragColor = outputColor_S0 * output_S1;
//   25    }
//   26    }
//   27
// Errors:
// (unknown error)
// Shader compilation error
// ------------------------
//    1    #version 300 es
//    2
//    3    precision mediump float;
//    4    precision mediump sampler2D;
//    5    out mediump vec4 sk_FragColor;
//    6    in mediump vec4 vcolor_S0;
//    7    void main() {
//    8    mediump vec4 outputColor_S0 = vcolor_S0;
//    9    {
//   10    sk_FragColor = outputColor_S0;
//   11    }
//   12    }
//   13
// Errors:
// (unknown error)
// Shader compilation error
// ------------------------
//    1    #version 300 es
//    2
//    3    precision mediump float;
//    4    precision mediump sampler2D;
//    5    out mediump vec4 sk_FragColor;
//    6    uniform sampler2D uTextureSampler_0_S0;
//    7    in highp vec2 vTextureCoords_S0;
//    8    in highp float vTexIndex_S0;
//    9    in mediump vec4 vinColor_S0;
//   10    void main() {
//   11    mediump vec4 outputColor_S0 = vinColor_S0;
//   12    mediump vec4 texColor = texture(uTextureSampler_0_S0, vTextureCoords_S0, -0.475).xxxx;
//   13    mediump vec4 outputCoverage_S0 = texColor;
//   14    {
//   15    sk_FragColor = outputColor_S0 * outputCoverage_S0;
//   16    }
//   17    }
//   18

// ]
