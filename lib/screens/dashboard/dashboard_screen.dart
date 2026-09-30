import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/activity_model.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/animated_paw.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/custom_dialogs.dart';
import '../../widgets/pet_card.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  final StorageService storage;
  final VoidCallback onNavigateToPets;
  final VoidCallback onNavigateToAppointments;
  final VoidCallback onNavigateToServices;
  final VoidCallback onAddPet;

  const DashboardScreen({
    super.key,
    required this.storage,
    required this.onNavigateToPets,
    required this.onNavigateToAppointments,
    required this.onNavigateToServices,
    required this.onAddPet,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = widget.storage.totalPets;
    final vaccinated = widget.storage.vaccinatedCount;
    final vaxPercent = total > 0 ? ((vaccinated / total) * 100).round() : 0;
    final upcomingAppts = widget.storage.appointments
        .where((a) => a.status.toLowerCase() == 'confirmed' || a.status.toLowerCase() == 'pending')
        .take(3)
        .toList();
    final recentPets = widget.storage.pets.take(4).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP HERO BANNER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF0F766E), Color(0xFF115E59)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '🐾 Veterinary Management System',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${_getTimeGreeting()}, Doctor!',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'You have ${widget.storage.upcomingAppointmentsCount} scheduled appointments and $total patients registered today.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              onPressed: widget.onAddPet,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primaryDark,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.add_circle, size: 18),
                              label: const Text('Add Patient', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final appt = await CustomDialogs.showBookAppointmentDialog(
                                  context,
                                  pets: widget.storage.pets,
                                );
                                if (appt != null) {
                                  await widget.storage.addAppointment(appt);
                                  setState(() {});
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white70, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.calendar_today_rounded, size: 16),
                              label: const Text('Book Appointment', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const AnimatedPawBadge(size: 80, color: Colors.white),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),

            const SizedBox(height: 24),

            // STATS ROW (4 Cards)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final isMedium = constraints.maxWidth > 600;

                return GridView.count(
                  crossAxisCount: isWide ? 4 : (isMedium ? 2 : 1),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 1.4 : 1.7,
                  children: [
                    StatCard(
                      title: 'Total Registered Pets',
                      value: '$total',
                      subtitle: 'Active records',
                      icon: Icons.pets_rounded,
                      iconColor: AppColors.primary,
                      trend: '+12%',
                      isPositive: true,
                      animationDelayMs: 50,
                    ),
                    StatCard(
                      title: 'Dogs & Cats Ratio',
                      value: '${widget.storage.dogCount} 🐕 / ${widget.storage.catCount} 🐈',
                      subtitle: '${widget.storage.otherCount} other species',
                      icon: Icons.pie_chart_outline_rounded,
                      iconColor: AppColors.accent,
                      trend: 'Balanced',
                      isPositive: true,
                      animationDelayMs: 100,
                    ),
                    StatCard(
                      title: 'Upcoming Visits',
                      value: '${widget.storage.upcomingAppointmentsCount}',
                      subtitle: 'Visits scheduled',
                      icon: Icons.calendar_month_rounded,
                      iconColor: AppColors.info,
                      trend: 'Next 7 days',
                      isPositive: true,
                      animationDelayMs: 150,
                    ),
                    StatCard(
                      title: 'Vaccinated Rate',
                      value: '$vaxPercent%',
                      subtitle: '$vaccinated fully protected',
                      icon: Icons.verified_user_rounded,
                      iconColor: AppColors.success,
                      trend: 'Up-to-date',
                      isPositive: true,
                      animationDelayMs: 200,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // TWO-COLUMN SECTION: Recent Pets & Upcoming Visits
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;

                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildRecentPetsSection(recentPets, isDark)),
                          const SizedBox(width: 24),
                          Expanded(flex: 2, child: _buildUpcomingAppointmentsSection(upcomingAppts, isDark)),
                        ],
                      )
                    : Column(
                        children: [
                          _buildRecentPetsSection(recentPets, isDark),
                          const SizedBox(height: 24),
                          _buildUpcomingAppointmentsSection(upcomingAppts, isDark),
                        ],
                      );
              },
            ),

            const SizedBox(height: 32),

            // RECENT ACTIVITY LOG SECTION
            _buildActivityLogSection(isDark),
          ],
        ),
      ),
    );
  }

  // Recent Pets Widget
  Widget _buildRecentPetsSection(List recentPets, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.pets, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Recent Patients',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: widget.onNavigateToPets,
              icon: const Text('View All', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (recentPets.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('No pets registered yet. Click "Add Patient" to start!')),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.76,
            ),
            itemCount: recentPets.length,
            itemBuilder: (context, index) {
              final pet = recentPets[index];
              return PetCard(
                pet: pet,
                animationIndex: index,
                onTap: () => CustomDialogs.showPetDetails(context, pet),
                onEdit: () async {
                  final updated = await CustomDialogs.showAddEditPetDialog(context, pet: pet);
                  if (updated != null) {
                    await widget.storage.updatePet(updated);
                    setState(() {});
                  }
                },
                onDelete: () async {
                  final confirmed = await CustomDialogs.showDeleteConfirm(
                    context,
                    title: 'Remove Pet Record?',
                    message: 'Are you sure you want to remove ${pet.name} from records?',
                  );
                  if (confirmed == true) {
                    await widget.storage.deletePet(pet.id);
                    setState(() {});
                  }
                },
              );
            },
          ),
      ],
    );
  }

  // Upcoming Appointments Widget
  Widget _buildUpcomingAppointmentsSection(List upcomingAppts, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Upcoming Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: widget.onNavigateToAppointments,
              icon: const Text('All Visits', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (upcomingAppts.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: const Center(
              child: Text('No upcoming visits scheduled.'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingAppts.length,
            itemBuilder: (context, index) {
              final appt = upcomingAppts[index];
              return AppointmentCard(
                appointment: appt,
                index: index,
                onStatusChanged: (newStatus) async {
                  await widget.storage.updateAppointmentStatus(appt.id, newStatus);
                  setState(() {});
                },
                onDelete: () async {
                  await widget.storage.deleteAppointment(appt.id);
                  setState(() {});
                },
              );
            },
          ),
      ],
    );
  }

  // Recent Activity Feed Widget
  Widget _buildActivityLogSection(bool isDark) {
    final activities = PetActivity.sampleActivities;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondarySubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.history_rounded, color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Recent Clinical Activity Feed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final act = activities[index];
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: act.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(act.icon, color: act.color, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          act.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          act.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    act.timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
