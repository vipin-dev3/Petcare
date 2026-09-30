import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class AnimatedPawBadge extends StatelessWidget {
  final double size;
  final Color? color;
  final bool animate;

  const AnimatedPawBadge({
    super.key,
    this.size = 36,
    this.color,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final pawColor = color ?? AppColors.primary;

    Widget paw = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: pawColor.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.pets_rounded,
          size: size * 0.58,
          color: pawColor,
        ),
      ),
    );

    if (!animate) return paw;

    return paw
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.12, 1.12),
          duration: 1200.ms,
          curve: Curves.easeInOut,
        )
        .rotate(
          begin: -0.04,
          end: 0.04,
          duration: 1200.ms,
          curve: Curves.easeInOut,
        );
  }
}

class FloatingPawBackground extends StatelessWidget {
  const FloatingPawBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: 40,
            right: 80,
            child: Icon(
              Icons.pets_rounded,
              size: 110,
              color: AppColors.primary.withValues(alpha: 0.03),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: 0, end: -15, duration: 3000.ms, curve: Curves.easeInOut),
          ),
          Positioned(
            bottom: 60,
            left: 50,
            child: Icon(
              Icons.pets_rounded,
              size: 140,
              color: AppColors.accent.withValues(alpha: 0.03),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: 0, end: 15, duration: 3500.ms, curve: Curves.easeInOut),
          ),
        ],
      ),
    );
  }
}
