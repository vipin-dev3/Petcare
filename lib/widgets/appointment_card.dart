import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';
import '../theme/app_colors.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Function(String newStatus)? onStatusChanged;
  final VoidCallback? onDelete;
  final int index;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onStatusChanged,
    this.onDelete,
    this.index = 0,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'completed':
        return AppColors.info;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(appointment.status);
    final dateFormatted = DateFormat('EEE, MMM d, y').format(appointment.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date & Time Box
          Container(
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.primarySubtle.withValues(alpha: isDark ? 0.2 : 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('d').format(appointment.date),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(appointment.date).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appointment.time,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Main Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      appointment.petName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${appointment.petType})',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        appointment.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${appointment.serviceType} • $dateFormatted',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 14,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Owner: ${appointment.ownerName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.medical_information_outlined,
                      size: 14,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appointment.veterinarian,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action menu
          if (onStatusChanged != null || onDelete != null)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              onSelected: (val) {
                if (val == 'delete') {
                  onDelete?.call();
                } else {
                  onStatusChanged?.call(val);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'Confirmed', child: Text('Mark Confirmed')),
                const PopupMenuItem(value: 'Completed', child: Text('Mark Completed')),
                const PopupMenuItem(value: 'Cancelled', child: Text('Mark Cancelled')),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Appointment', style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 50 * index), duration: 300.ms)
        .slideX(begin: 0.05, end: 0, curve: Curves.easeOut);
  }
}
