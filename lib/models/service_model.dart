import 'package:flutter/material.dart';

class PetService {
  final String id;
  final String title;
  final String category;
  final String description;
  final double price;
  final String duration;
  final double rating;
  final int reviewsCount;
  final IconData icon;
  final List<String> highlights;

  const PetService({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.duration,
    required this.rating,
    required this.reviewsCount,
    required this.icon,
    required this.highlights,
  });

  static List<PetService> get availableServices => const [
        PetService(
          id: 'srv-1',
          title: 'Comprehensive Vet Checkup',
          category: 'Medical',
          description:
              'Complete nose-to-tail physical exam, vital organ check, ear & eye inspection, and heart rate monitoring.',
          price: 55.00,
          duration: '30-45 min',
          rating: 4.9,
          reviewsCount: 142,
          icon: Icons.medical_services_rounded,
          highlights: ['Full Vital Signs', 'Dental Assessment', 'Nutrition Consult'],
        ),
        PetService(
          id: 'srv-2',
          title: 'Luxury Grooming & Spa',
          category: 'Grooming',
          description:
              'Hypoallergenic warm bath, blow dry, breed-standard styling, nail clip, ear cleaning, and paw pad balm.',
          price: 65.00,
          duration: '60-90 min',
          rating: 4.8,
          reviewsCount: 218,
          icon: Icons.shower_rounded,
          highlights: ['Aromatherapy Bath', 'Sanitary Trim', 'Paw Massage'],
        ),
        PetService(
          id: 'srv-3',
          title: 'Vaccination & Prevention',
          category: 'Medical',
          description:
              'Core vaccinations (Rabies, DHPP, FVRCP) plus flea, tick, and heartworm preventative treatment.',
          price: 45.00,
          duration: '20 min',
          rating: 5.0,
          reviewsCount: 96,
          icon: Icons.vaccines_rounded,
          highlights: ['Certified Vaccines', 'Health Certificate', 'Parasite Check'],
        ),
        PetService(
          id: 'srv-4',
          title: 'Pet Hotel & Day Care',
          category: 'Boarding',
          description:
              'Climate-controlled private suites, 24/7 web camera access, group playtimes, and customized chef meals.',
          price: 40.00,
          duration: 'Per Day',
          rating: 4.9,
          reviewsCount: 180,
          icon: Icons.cottage_rounded,
          highlights: ['24/7 Live Stream', 'Indoor Park', 'Medication Administered'],
        ),
        PetService(
          id: 'srv-5',
          title: 'Dental Scaling & Polish',
          category: 'Dental',
          description:
              'Ultrasonic plaque and tartar removal, enamel polishing, gum health check, and fresh breath rinse.',
          price: 85.00,
          duration: '45 min',
          rating: 4.7,
          reviewsCount: 75,
          icon: Icons.clean_hands_rounded,
          highlights: ['Ultrasonic Scaling', 'Cavity Inspection', 'Freshening Rinse'],
        ),
        PetService(
          id: 'srv-6',
          title: 'Obedience & Behavior Training',
          category: 'Training',
          description:
              'Positive reinforcement training for leash manners, recall, socialization, and resolving anxiety or barking.',
          price: 70.00,
          duration: '60 min',
          rating: 4.9,
          reviewsCount: 110,
          icon: Icons.school_rounded,
          highlights: ['Certified Trainer', 'Custom Routine', 'Parent Coaching'],
        ),
      ];
}
