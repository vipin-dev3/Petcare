import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pet_model.dart';
import '../services/image_picker_helper.dart';
import '../theme/app_colors.dart';

class PetCard extends StatefulWidget {
  final Pet pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final int animationIndex;

  const PetCard({
    super.key,
    required this.pet,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    this.animationIndex = 0,
  });

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  bool _isHovered = false;

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return AppColors.success;
      case 'vaccinated':
        return AppColors.primary;
      case 'needs checkup':
        return AppColors.warning;
      case 'treatment':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  String _getPetTypeEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'dog':
        return '🐕';
      case 'cat':
        return '🐈';
      case 'bird':
        return '🦜';
      case 'rabbit':
        return '🐰';
      default:
        return '🐾';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(widget.pet.healthStatus);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: _isHovered
              ? Matrix4.translationValues(0, -6, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.6)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 10 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PET IMAGE HEADER WITH BADGES
                Stack(
                  children: [
                    SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: ImagePickerHelper.buildPetImage(
                        widget.pet.image,
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Gradient overlay at top/bottom of image
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Species badge (top left)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24, width: 0.8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getPetTypeEmoji(widget.pet.type),
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.pet.type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Health status pill (top right)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.pet.healthStatus,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // DETAILS CONTENT
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Breed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.pet.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.pet.gender,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.pet.breed,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Quick Metric Chips (Age, Weight, Owner)
                      Row(
                        children: [
                          _buildDetailPill(
                            context,
                            Icons.cake_rounded,
                            widget.pet.age,
                            isDark,
                          ),
                          const SizedBox(width: 8),
                          _buildDetailPill(
                            context,
                            Icons.scale_rounded,
                            widget.pet.weight,
                            isDark,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Owner info row
                      Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 14,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.pet.owner,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.pet.isVaccinated)
                            Tooltip(
                              message: 'Vaccinated',
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.successSubtle,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.verified_rounded,
                                  size: 14,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      const Divider(height: 1),
                      const SizedBox(height: 10),

                      // Actions Row (Edit, Delete, View)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: widget.onTap,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              child: Text(
                                'Details',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: widget.onEdit,
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            tooltip: 'Edit Pet',
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primarySubtle,
                              foregroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            onPressed: widget.onDelete,
                            icon: const Icon(Icons.delete_outline_rounded, size: 18),
                            tooltip: 'Delete Pet',
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.errorSubtle,
                              foregroundColor: AppColors.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 60 * widget.animationIndex), duration: 350.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
  }

  Widget _buildDetailPill(
      BuildContext context, IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
