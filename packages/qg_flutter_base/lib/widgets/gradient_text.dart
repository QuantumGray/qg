import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final Gradient gradient;
  final TextStyle? style;
  final BlendMode blendMode;
  final String text;
  final ImageShader? imageShader;

  const GradientText({
    Key? key,
    required this.gradient,
    this.style,
    this.blendMode = BlendMode.modulate,
    required this.text,
    this.imageShader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Shader shader;
    return ShaderMask(
      blendMode: blendMode,
      shaderCallback: (Rect bounds) {
        // ignore: join_return_with_assignment
        shader = imageShader ??
            gradient
                .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        return shader;
      },
      child: Text(
        text,
        style: style?.copyWith(
          foreground: Paint()..shader = shader,
        ),
      ),
    );
  }
}
