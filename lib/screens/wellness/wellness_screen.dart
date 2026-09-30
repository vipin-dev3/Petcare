import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';

class WellnessScreen extends StatelessWidget {
  final StorageService storage;

  const WellnessScreen({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '❤️ Wellness & Preventative Care',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Vaccination timelines, dietary guidelines, and proactive veterinary health protocols',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // VACCINE SCHEDULE TABLE / CARDS
            Text(
              'Essential Vaccine Schedules',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildVaccineCard(
              species: 'Canine (Dogs)',
              vaccine: 'Rabies & DHPP (Distemper, Hepatitis, Parvovirus, Parainfluenza)',
              timing: 'Initial series at 6-8 weeks; Booster annually or every 3 years',
              protection: 'Guards against fatal viral infections and respiratory attacks',
              badge: 'Critical Core',
              isDark: isDark,
            ),
            const SizedBox(height: 10),
            _buildVaccineCard(
              species: 'Feline (Cats)',
              vaccine: 'FVRCP (Feline Viral Rhinotracheitis, Calicivirus, Panleukopenia)',
              timing: 'Starting at 6-8 weeks, booster every 1-3 years',
              protection: 'Protects against upper respiratory viruses and feline distemper',
              badge: 'Critical Core',
              isDark: isDark,
            ),
            const SizedBox(height: 10),
            _buildVaccineCard(
              species: 'Canine (Dogs)',
              vaccine: 'Bordetella (Kennel Cough) & Leptospirosis',
              timing: 'Every 6-12 months for social / boarded dogs',
              protection: 'Prevents bacterial transmission in dog parks, grooming & boarding',
              badge: 'Recommended',
              isDark: isDark,
            ),

            const SizedBox(height: 28),

            // HEALTH CHECKLIST SECTION
            Text(
              'Daily Wellness & Vitality Pillars',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),

            LayoutBuilder(
              builder: (context, constraints) {
                int count = constraints.maxWidth > 800 ? 3 : 1;
                return GridView.count(
                  crossAxisCount: count,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: count == 3 ? 1.25 : 2.5,
                  children: [
                    _buildPillarCard(
                      icon: Icons.water_drop_rounded,
                      iconColor: AppColors.info,
                      title: 'Hydration & Nutrition',
                      description:
                          'Fresh clean water must be accessible 24/7. Provide age-appropriate, AAFCO-certified balanced diets.',
                      isDark: isDark,
                    ),
                    _buildPillarCard(
                      icon: Icons.directions_run_rounded,
                      iconColor: AppColors.accent,
                      title: 'Physical & Mental Exercise',
                      description:
                          'Minimum 30-60 minutes daily activity for dogs, interactive feather toys and scratching posts for cats.',
                      isDark: isDark,
                    ),
                    _buildPillarCard(
                      icon: Icons.clean_hands_rounded,
                      iconColor: AppColors.success,
                      title: 'Coat & Dental Care',
                      description:
                          'Brush teeth 2-3x weekly to prevent periodontal disease. Check ears and paws weekly for mites and cuts.',
                      isDark: isDark,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

            // EMERGENCY HELPLINE CARD
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.errorSubtle.withValues(alpha: isDark ? 0.15 : 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emergency_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '24/7 Pet Emergency & Poison Hotline',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Call immediately if your pet exhibits breathing difficulty, ingestion of toxic substances (chocolate, lilies, xylitol), or severe trauma.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Emergency Hotline: +1 (800) 222-1222'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Call +1 (800) 222-1222'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccineCard({
    required String species,
    required String vaccine,
    required String timing,
    required String protection,
    required String badge,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primarySubtle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.vaccines_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vaccine,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primarySubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Species: $species • Timing: $timing',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  protection,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
