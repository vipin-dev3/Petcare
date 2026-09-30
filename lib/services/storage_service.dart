import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet_model.dart';
import '../models/appointment_model.dart';

class StorageService {
  static const String _petsKey = 'petcare_pets_v2';
  static const String _appointmentsKey = 'petcare_appointments_v2';
  static const String _initializedKey = 'petcare_initialized_v2';

  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  List<Pet> _pets = [];
  List<Appointment> _appointments = [];

  List<Pet> get pets => List.unmodifiable(_pets);
  List<Appointment> get appointments => List.unmodifiable(_appointments);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isInitialized = prefs.getBool(_initializedKey) ?? false;

    if (!isInitialized) {
      // First run: load initial rich sample data
      _pets = Pet.samplePets;
      _appointments = Appointment.sampleAppointments;
      await _persistPets(prefs);
      await _persistAppointments(prefs);
      await prefs.setBool(_initializedKey, true);
    } else {
      // Load saved pets
      final petsData = prefs.getString(_petsKey);
      if (petsData != null) {
        try {
          final List list = jsonDecode(petsData);
          _pets = list.map((e) => Pet.fromJson(e)).toList();
        } catch (_) {
          _pets = Pet.samplePets;
        }
      } else {
        _pets = Pet.samplePets;
      }

      // Load saved appointments
      final apptData = prefs.getString(_appointmentsKey);
      if (apptData != null) {
        try {
          final List list = jsonDecode(apptData);
          _appointments = list.map((e) => Appointment.fromJson(e)).toList();
        } catch (_) {
          _appointments = Appointment.sampleAppointments;
        }
      } else {
        _appointments = Appointment.sampleAppointments;
      }
    }
  }

  Future<void> _persistPets(SharedPreferences prefs) async {
    final jsonString = jsonEncode(_pets.map((e) => e.toJson()).toList());
    await prefs.setString(_petsKey, jsonString);
  }

  Future<void> _persistAppointments(SharedPreferences prefs) async {
    final jsonString = jsonEncode(_appointments.map((e) => e.toJson()).toList());
    await prefs.setString(_appointmentsKey, jsonString);
  }

  // Pet CRUD
  Future<void> addPet(Pet pet) async {
    _pets.insert(0, pet);
    final prefs = await SharedPreferences.getInstance();
    await _persistPets(prefs);
  }

  Future<void> updatePet(Pet pet) async {
    final index = _pets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      _pets[index] = pet;
      final prefs = await SharedPreferences.getInstance();
      await _persistPets(prefs);
    }
  }

  Future<void> deletePet(String id) async {
    _pets.removeWhere((p) => p.id == id);
    final prefs = await SharedPreferences.getInstance();
    await _persistPets(prefs);
  }

  // Appointment CRUD
  Future<void> addAppointment(Appointment appt) async {
    _appointments.insert(0, appt);
    final prefs = await SharedPreferences.getInstance();
    await _persistAppointments(prefs);
  }

  Future<void> updateAppointmentStatus(String id, String newStatus) async {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index].status = newStatus;
      final prefs = await SharedPreferences.getInstance();
      await _persistAppointments(prefs);
    }
  }

  Future<void> deleteAppointment(String id) async {
    _appointments.removeWhere((a) => a.id == id);
    final prefs = await SharedPreferences.getInstance();
    await _persistAppointments(prefs);
  }

  // Stats calculation
  int get totalPets => _pets.length;
  int get dogCount => _pets.where((p) => p.type.toLowerCase() == 'dog').length;
  int get catCount => _pets.where((p) => p.type.toLowerCase() == 'cat').length;
  int get otherCount => _pets.where((p) => p.type.toLowerCase() != 'dog' && p.type.toLowerCase() != 'cat').length;
  int get vaccinatedCount => _pets.where((p) => p.isVaccinated).length;
  int get upcomingAppointmentsCount =>
      _appointments.where((a) => a.status.toLowerCase() == 'confirmed' || a.status.toLowerCase() == 'pending').length;
}
