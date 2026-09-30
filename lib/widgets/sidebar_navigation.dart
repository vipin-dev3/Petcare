import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'animated_paw.dart';

class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onAddPet;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;
  final bool isDarkMode;
  final String userName;

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onAddPet,
    required this.onToggleTheme,
    required this.onLogout,
    required this.isDarkMode,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Brand Logo & Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                const AnimatedPawBadge(size: 42, color: AppColors.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'PetCare ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          letterSpacing: -0.5,
                        ),
                        children: const [
                          TextSpan(
                            text: 'PRO',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Veterinary & Care Hub',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick Action: Add New Pet Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: onAddPet,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: const Text(
                'Register New Pet',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),

          const SizedBox(height: 12),
          const Divider(indent: 20, endIndent: 20, height: 1),
          const SizedBox(height: 12),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  badge: null,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.pets_rounded,
                  label: 'Pets Directory',
                  badge: null,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.calendar_month_rounded,
                  label: 'Appointments',
                  badge: 'New',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.medical_services_rounded,
                  label: 'Clinic Services',
                  badge: null,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.favorite_rounded,
                  label: 'Wellness & Health',
                  badge: null,
                ),
              ],
            ),
          ),

          // User Profile & Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBg.withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primarySubtle,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Clinic Admin',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Dark Mode Toggle
                    IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        size: 20,
                        color: isDarkMode ? Colors.amber : AppColors.lightTextSecondary,
                      ),
                      tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      onPressed: onToggleTheme,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: onLogout,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: const Text('Log Out', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    String? badge,
  }) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySubtle.withValues(alpha: 0.8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: () => onDestinationSelected(index),
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.lightTextSecondary,
            size: 22,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primaryDark : null,
            ),
          ),
          trailing: badge != null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : (isSelected
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null),
        ),
      ),
    );
  }
}
