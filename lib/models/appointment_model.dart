class Appointment {
  final String id;
  final String petName;
  final String petType;
  final String ownerName;
  final String serviceType; // Routine Checkup, Full Grooming, Vaccination, Dental Care, Surgery
  final DateTime date;
  final String time;
  final String veterinarian;
  String status; // Confirmed, Pending, Completed, Cancelled
  final String notes;

  Appointment({
    required this.id,
    required this.petName,
    required this.petType,
    required this.ownerName,
    required this.serviceType,
    required this.date,
    required this.time,
    this.veterinarian = 'Dr. Emily Vance, DVM',
    this.status = 'Confirmed',
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'petName': petName,
        'petType': petType,
        'ownerName': ownerName,
        'serviceType': serviceType,
        'date': date.toIso8601String(),
        'time': time,
        'veterinarian': veterinarian,
        'status': status,
        'notes': notes,
      };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        petName: json['petName'] ?? '',
        petType: json['petType'] ?? 'Dog',
        ownerName: json['ownerName'] ?? '',
        serviceType: json['serviceType'] ?? 'Routine Checkup',
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now().add(const Duration(days: 1)),
        time: json['time'] ?? '10:00 AM',
        veterinarian: json['veterinarian'] ?? 'Dr. Emily Vance, DVM',
        status: json['status'] ?? 'Confirmed',
        notes: json['notes'] ?? '',
      );

  static List<Appointment> get sampleAppointments => [
        Appointment(
          id: 'apt-1',
          petName: 'Bella',
          petType: 'Dog',
          ownerName: 'Sarah Jenkins',
          serviceType: 'Annual Vaccination',
          date: DateTime.now().add(const Duration(days: 1)),
          time: '09:30 AM',
          veterinarian: 'Dr. Emily Vance, DVM',
          status: 'Confirmed',
          notes: 'Booster shots for rabies and parvovirus.',
        ),
        Appointment(
          id: 'apt-2',
          petName: 'Milo',
          petType: 'Cat',
          ownerName: 'David Chen',
          serviceType: 'Spa & Grooming',
          date: DateTime.now().add(const Duration(days: 2)),
          time: '02:00 PM',
          veterinarian: 'Master Stylist Jessica',
          status: 'Confirmed',
          notes: 'Bath, brush, nail trim, and ear cleaning.',
        ),
        Appointment(
          id: 'apt-3',
          petName: 'Charlie',
          petType: 'Dog',
          ownerName: 'Emily Watson',
          serviceType: 'Skin Allergy Check',
          date: DateTime.now().add(const Duration(days: 3)),
          time: '11:15 AM',
          veterinarian: 'Dr. Marcus Ross',
          status: 'Pending',
          notes: 'Persistent itching around ears and paws.',
        ),
        Appointment(
          id: 'apt-4',
          petName: 'Snowball',
          petType: 'Rabbit',
          ownerName: 'Olivia Smith',
          serviceType: 'Routine Wellness',
          date: DateTime.now().subtract(const Duration(days: 4)),
          time: '04:00 PM',
          veterinarian: 'Dr. Emily Vance, DVM',
          status: 'Completed',
          notes: 'General health is good, weight stable.',
        ),
      ];
}
