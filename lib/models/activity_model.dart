import 'package:flutter/material.dart';

class PetActivity {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final IconData icon;
  final Color color;

  const PetActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.icon,
    required this.color,
  });

  static List<PetActivity> get sampleActivities => const [
        PetActivity(
          id: 'act-1',
          title: 'Vaccine Administered',
          description: 'Bella received Rabies Booster Shot',
          timeAgo: '2 hours ago',
          icon: Icons.vaccines_rounded,
          color: Color(0xFF10B981),
        ),
        PetActivity(
          id: 'act-2',
          title: 'Grooming Completed',
          description: 'Milo completed full spa & nail trim session',
          timeAgo: '5 hours ago',
          icon: Icons.shower_rounded,
          color: Color(0xFF0D9488),
        ),
        PetActivity(
          id: 'act-3',
          title: 'New Pet Registered',
          description: 'Snowball (Holland Lop) was added to system',
          timeAgo: '1 day ago',
          icon: Icons.pets_rounded,
          color: Color(0xFFF97316),
        ),
        PetActivity(
          id: 'act-4',
          title: 'Prescription Refilled',
          description: 'Allergy relief tablets issued for Charlie',
          timeAgo: '2 days ago',
          icon: Icons.medication_rounded,
          color: Color(0xFF6366F1),
        ),
      ];
}
