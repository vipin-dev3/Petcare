import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/custom_dialogs.dart';

class AppointmentsScreen extends StatefulWidget {
  final StorageService storage;

  const AppointmentsScreen({super.key, required this.storage});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String _selectedStatus = 'All';
  final List<String> _statuses = ['All', 'Confirmed', 'Pending', 'Completed', 'Cancelled'];

  List<Appointment> _getFilteredAppointments() {
    if (_selectedStatus == 'All') {
      return widget.storage.appointments;
    }
    return widget.storage.appointments
        .where((a) => a.status.toLowerCase() == _selectedStatus.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = _getFilteredAppointments();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📅 Appointment Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monitor scheduled veterinary visits, treatments, and grooming slots',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
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
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                  label: const Text('Schedule Visit', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Status Filter Tabs
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _statuses.map((status) {
                    final isSelected = _selectedStatus == status;
                    final count = status == 'All'
                        ? widget.storage.appointments.length
                        : widget.storage.appointments
                            .where((a) => a.status.toLowerCase() == status.toLowerCase())
                            .length;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text('$status ($count)'),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => _selectedStatus = status);
                        },
                        selectedColor: AppColors.primarySubtle,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primaryDark : null,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Appointments List
            if (list.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event_busy_rounded, size: 64, color: AppColors.lightTextMuted),
                    const SizedBox(height: 16),
                    Text(
                      'No ${_selectedStatus == "All" ? "" : "$_selectedStatus "}appointments found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Book a new appointment slot for an existing or new patient.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
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
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Book Appointment'),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final appt = list[index];
                  return AppointmentCard(
                    appointment: appt,
                    index: index,
                    onStatusChanged: (newStatus) async {
                      await widget.storage.updateAppointmentStatus(appt.id, newStatus);
                      setState(() {});
                    },
                    onDelete: () async {
                      final confirmed = await CustomDialogs.showDeleteConfirm(
                        context,
                        title: 'Cancel Appointment?',
                        message: 'Are you sure you want to remove appointment for ${appt.petName}?',
                      );
                      if (confirmed == true) {
                        await widget.storage.deleteAppointment(appt.id);
                        setState(() {});
                      }
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
