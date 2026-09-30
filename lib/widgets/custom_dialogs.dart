import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pet_model.dart';
import '../models/appointment_model.dart';
import '../services/image_picker_helper.dart';
import '../theme/app_colors.dart';

class CustomDialogs {
  // Show Add or Edit Pet Dialog
  static Future<Pet?> showAddEditPetDialog(BuildContext context, {Pet? pet}) {
    return showDialog<Pet>(
      context: context,
      builder: (ctx) => _AddEditPetDialogContent(pet: pet),
    );
  }

  // Show Book Appointment Dialog
  static Future<Appointment?> showBookAppointmentDialog(
    BuildContext context, {
    List<Pet> pets = const [],
    String? preselectedService,
  }) {
    return showDialog<Appointment>(
      context: context,
      builder: (ctx) => _BookAppointmentDialogContent(
        pets: pets,
        initialService: preselectedService,
      ),
    );
  }

  // Show Pet Details Modal Sheet
  static void showPetDetails(BuildContext context, Pet pet, {VoidCallback? onEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PetDetailsSheet(pet: pet, onEdit: onEdit),
    );
  }

  // Show Delete Confirmation
  static Future<bool?> showDeleteConfirm(BuildContext context, {required String title, required String message}) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// ADD / EDIT PET DIALOG CONTENT
// -------------------------------------------------------------
class _AddEditPetDialogContent extends StatefulWidget {
  final Pet? pet;
  const _AddEditPetDialogContent({this.pet});

  @override
  State<_AddEditPetDialogContent> createState() => _AddEditPetDialogContentState();
}

class _AddEditPetDialogContentState extends State<_AddEditPetDialogContent> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ownerController;
  late TextEditingController _contactController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _notesController;

  late String _selectedType;
  late String _selectedGender;
  late String _selectedStatus;
  late bool _isVaccinated;
  String? _imageSource;

  final List<String> _types = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other'];
  final List<String> _statuses = ['Healthy', 'Vaccinated', 'Needs Checkup', 'Treatment'];

  @override
  void initState() {
    super.initState();
    final p = widget.pet;
    _nameController = TextEditingController(text: p?.name ?? '');
    _ownerController = TextEditingController(text: p?.owner ?? '');
    _contactController = TextEditingController(text: p?.contact ?? '+1 (555) 019-2834');
    _breedController = TextEditingController(text: p?.breed ?? '');
    _ageController = TextEditingController(text: p?.age ?? '2 years');
    _weightController = TextEditingController(text: p?.weight ?? '5.0 kg');
    _notesController = TextEditingController(text: p?.notes ?? '');

    _selectedType = p?.type ?? 'Dog';
    _selectedGender = p?.gender ?? 'Male';
    _selectedStatus = p?.healthStatus ?? 'Healthy';
    _isVaccinated = p?.isVaccinated ?? true;
    _imageSource = p?.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _contactController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final base64Image = await ImagePickerHelper.pickImageAsBase64();
    if (base64Image != null) {
      setState(() => _imageSource = base64Image);
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final pet = Pet(
        id: widget.pet?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        owner: _ownerController.text.trim(),
        contact: _contactController.text.trim(),
        type: _selectedType,
        breed: _breedController.text.trim().isEmpty ? 'Mixed Breed' : _breedController.text.trim(),
        age: _ageController.text.trim().isEmpty ? '1 year' : _ageController.text.trim(),
        weight: _weightController.text.trim().isEmpty ? '5.0 kg' : _weightController.text.trim(),
        gender: _selectedGender,
        healthStatus: _selectedStatus,
        image: _imageSource,
        notes: _notesController.text.trim(),
        isVaccinated: _isVaccinated,
      );
      Navigator.pop(context, pet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.pet != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primarySubtle.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.pets, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isEditing ? 'Edit Pet Profile' : 'Register New Pet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Scrollable Form Fields
                Expanded(
                  child: ListView(
                    children: [
                      // Pet Image Picker Row
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 2.5),
                              ),
                              child: ClipOval(
                                child: ImagePickerHelper.buildPetImage(
                                  _imageSource,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Species Selection Pills
                      const Text(
                        'Pet Species',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _types.map((type) {
                          final isSelected = _selectedType == type;
                          return ChoiceChip(
                            label: Text(type),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedType = type);
                            },
                            selectedColor: AppColors.primarySubtle,
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.primaryDark : null,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Name & Breed Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Pet Name *',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _breedController,
                              decoration: const InputDecoration(
                                labelText: 'Breed',
                                prefixIcon: Icon(Icons.cruelty_free_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Age, Weight, Gender
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              decoration: const InputDecoration(
                                labelText: 'Age (e.g. 2 yrs)',
                                prefixIcon: Icon(Icons.cake_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _weightController,
                              decoration: const InputDecoration(
                                labelText: 'Weight (e.g. 8 kg)',
                                prefixIcon: Icon(Icons.scale_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedGender,
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: Icon(Icons.transgender),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Male', child: Text('Male')),
                                DropdownMenuItem(value: 'Female', child: Text('Female')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedGender = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Owner Name & Contact
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ownerController,
                              decoration: const InputDecoration(
                                labelText: 'Owner Name *',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _contactController,
                              decoration: const InputDecoration(
                                labelText: 'Owner Contact',
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Health Status Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Health Status',
                          prefixIcon: Icon(Icons.healing_outlined),
                        ),
                        items: _statuses
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedStatus = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Vaccinated Switch
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Vaccinations Up-To-Date', style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: const Text('Pet has received core vaccinations'),
                        value: _isVaccinated,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) => setState(() => _isVaccinated = val),
                      ),
                      const SizedBox(height: 8),

                      // Notes Field
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Care Notes / Medical History',
                          hintText: 'Allergies, favorite snacks, behavioral notes...',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(isEditing ? 'Save Changes' : 'Register Pet'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// BOOK APPOINTMENT DIALOG CONTENT
// -------------------------------------------------------------
class _BookAppointmentDialogContent extends StatefulWidget {
  final List<Pet> pets;
  final String? initialService;

  const _BookAppointmentDialogContent({required this.pets, this.initialService});

  @override
  State<_BookAppointmentDialogContent> createState() => _BookAppointmentDialogContentState();
}

class _BookAppointmentDialogContentState extends State<_BookAppointmentDialogContent> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPetId;
  late String _selectedService;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '10:00 AM';
  String _selectedVet = 'Dr. Emily Vance, DVM';
  final _notesController = TextEditingController();

  final List<String> _services = [
    'Comprehensive Vet Checkup',
    'Luxury Grooming & Spa',
    'Vaccination & Prevention',
    'Pet Hotel & Day Care',
    'Dental Scaling & Polish',
    'Obedience & Behavior Training',
  ];

  final List<String> _times = [
    '09:00 AM',
    '10:00 AM',
    '11:30 AM',
    '01:30 PM',
    '03:00 PM',
    '04:30 PM',
  ];

  final List<String> _vets = [
    'Dr. Emily Vance, DVM',
    'Dr. Marcus Ross, Vet Surgeon',
    'Dr. Amanda Lee, Dermatologist',
    'Master Stylist Jessica (Grooming)',
  ];

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialService ?? _services.first;
    if (widget.pets.isNotEmpty) {
      _selectedPetId = widget.pets.first.id;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _book() {
    if (_formKey.currentState!.validate()) {
      Pet? pet;
      if (widget.pets.isNotEmpty && _selectedPetId != null) {
        pet = widget.pets.firstWhere((p) => p.id == _selectedPetId);
      }

      final appt = Appointment(
        id: 'apt-${DateTime.now().millisecondsSinceEpoch}',
        petName: pet?.name ?? 'Guest Pet',
        petType: pet?.type ?? 'Pet',
        ownerName: pet?.owner ?? 'Registered Client',
        serviceType: _selectedService,
        date: _selectedDate,
        time: _selectedTime,
        veterinarian: _selectedVet,
        status: 'Confirmed',
        notes: _notesController.text.trim(),
      );

      Navigator.pop(context, appt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.accentSubtle.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.calendar_month_rounded, color: AppColors.accent, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Schedule Care Visit',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                Expanded(
                  child: ListView(
                    children: [
                      // Select Pet Dropdown
                      if (widget.pets.isNotEmpty) ...[
                        DropdownButtonFormField<String>(
                          initialValue: _selectedPetId,
                          decoration: const InputDecoration(
                            labelText: 'Select Patient (Pet) *',
                            prefixIcon: Icon(Icons.pets),
                          ),
                          items: widget.pets.map((p) {
                            return DropdownMenuItem(
                              value: p.id,
                              child: Text('${p.name} (${p.type} - Owner: ${p.owner})'),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedPetId = val),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Select Service
                      DropdownButtonFormField<String>(
                        initialValue: _services.contains(_selectedService) ? _selectedService : _services.first,
                        decoration: const InputDecoration(
                          labelText: 'Required Service *',
                          prefixIcon: Icon(Icons.medical_services_outlined),
                        ),
                        items: _services
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedService = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Date & Time Picker
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 90)),
                                );
                                if (picked != null) {
                                  setState(() => _selectedDate = picked);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Appointment Date',
                                  prefixIcon: Icon(Icons.event),
                                ),
                                child: Text(
                                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedTime,
                              decoration: const InputDecoration(
                                labelText: 'Preferred Slot',
                                prefixIcon: Icon(Icons.access_time),
                              ),
                              items: _times
                                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedTime = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Assigned Professional
                      DropdownButtonFormField<String>(
                        initialValue: _selectedVet,
                        decoration: const InputDecoration(
                          labelText: 'Veterinarian / Specialist',
                          prefixIcon: Icon(Icons.person_pin_outlined),
                        ),
                        items: _vets
                            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedVet = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Notes
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Visit Notes / Symptoms',
                          hintText: 'Describe reason for visit or special instructions...',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _book,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Confirm Booking'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// PET DETAILS MODAL SHEET
// -------------------------------------------------------------
class _PetDetailsSheet extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onEdit;

  const _PetDetailsSheet({required this.pet, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (ctx, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Top Profile Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ImagePickerHelper.buildPetImage(
                    pet.image,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            pet.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              pet.type,
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${pet.breed} • ${pet.gender}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: pet.isVaccinated ? AppColors.successSubtle : AppColors.warningSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              pet.isVaccinated ? Icons.verified : Icons.warning_amber,
                              size: 14,
                              color: pet.isVaccinated ? AppColors.success : AppColors.warning,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              pet.isVaccinated ? 'Fully Vaccinated' : 'Vaccines Needed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: pet.isVaccinated ? AppColors.success : AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Vitals Grid
            Row(
              children: [
                _buildInfoCard('Age', pet.age, Icons.cake_outlined, isDark),
                const SizedBox(width: 12),
                _buildInfoCard('Weight', pet.weight, Icons.scale_outlined, isDark),
                const SizedBox(width: 12),
                _buildInfoCard('Status', pet.healthStatus, Icons.favorite_outline, isDark),
              ],
            ),

            const SizedBox(height: 24),

            // Owner Details
            Text(
              'Owner & Guardian Contact',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 20, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        pet.owner,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 20, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        pet.contact,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notes
            Text(
              'Care Notes & Medical History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Text(
                pet.notes.isEmpty ? 'No specific notes recorded for this pet.' : pet.notes,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onEdit?.call();
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      CustomDialogs.showBookAppointmentDialog(context, pets: [pet]);
                    },
                    icon: const Icon(Icons.calendar_today_rounded),
                    label: const Text('Book Visit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
