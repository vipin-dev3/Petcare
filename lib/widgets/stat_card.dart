import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color? iconBgColor;
  final String? subtitle;
  final String? trend;
  final bool isPositive;
  final int animationDelayMs;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.iconBgColor,
    this.subtitle,
    this.trend,
    this.isPositive = true,
    this.animationDelayMs = 0,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgIconColor = widget.iconBgColor ?? widget.iconColor.withValues(alpha: 0.12);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: _isHovered
            ? Matrix4.translationValues(0, -4, 0)
            : Matrix4.identity(),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isHovered
                ? widget.iconColor.withValues(alpha: 0.5)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.iconColor.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: _isHovered ? 18 : 8,
              offset: Offset(0, _isHovered ? 8 : 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgIconColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 24,
                  ),
                ),
                if (widget.trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.isPositive
                          ? AppColors.successSubtle
                          : AppColors.errorSubtle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.isPositive
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: 12,
                          color: widget.isPositive
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.trend!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: widget.isPositive
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    widget.subtitle!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.animationDelayMs), duration: 400.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad);
  }
}
