import 'package:flutter_test/flutter_test.dart';
import 'package:petcare_flutter_pro/models/pet_model.dart';
import 'package:petcare_flutter_pro/models/appointment_model.dart';
import 'package:petcare_flutter_pro/services/storage_service.dart';
import 'package:petcare_flutter_pro/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pet Model Tests', () {
    test('Pet serialization and deserialization works correctly', () {
      final pet = Pet(
        id: 'test-1',
        name: 'Buddy',
        owner: 'Alice',
        contact: '+1 555-0100',
        type: 'Dog',
        breed: 'Labrador',
        age: '2 yrs',
        weight: '25 kg',
        gender: 'Male',
        healthStatus: 'Healthy',
        image: 'https://example.com/pet.jpg',
        notes: 'Enjoys swimming',
        isVaccinated: true,
      );

      final json = pet.toJson();
      final fromJson = Pet.fromJson(json);

      expect(fromJson.id, 'test-1');
      expect(fromJson.name, 'Buddy');
      expect(fromJson.owner, 'Alice');
      expect(fromJson.type, 'Dog');
      expect(fromJson.breed, 'Labrador');
      expect(fromJson.isVaccinated, true);
    });
  });

  group('Appointment Model Tests', () {
    test('Appointment serialization and deserialization works correctly', () {
      final appt = Appointment(
        id: 'apt-test',
        petName: 'Milo',
        petType: 'Cat',
        ownerName: 'Bob',
        serviceType: 'Grooming',
        date: DateTime(2026, 10, 15),
        time: '11:00 AM',
        veterinarian: 'Dr. Vance',
        status: 'Confirmed',
        notes: 'Gentle handling',
      );

      final json = appt.toJson();
      final fromJson = Appointment.fromJson(json);

      expect(fromJson.id, 'apt-test');
      expect(fromJson.petName, 'Milo');
      expect(fromJson.serviceType, 'Grooming');
      expect(fromJson.status, 'Confirmed');
    });
  });

  group('StorageService CRUD Tests', () {
    test('StorageService initializes sample data and handles CRUD', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = StorageService();
      await storage.init();

      expect(storage.totalPets, greaterThan(0));
      expect(storage.appointments, isNotEmpty);

      final initialCount = storage.totalPets;
      final newPet = Pet(
        id: 'new-pet-99',
        name: 'Rocky',
        owner: 'Mark',
        type: 'Dog',
        age: '1 year',
      );

      await storage.addPet(newPet);
      expect(storage.totalPets, initialCount + 1);
      expect(storage.pets.first.name, 'Rocky');

      newPet.name = 'Rocky Balboa';
      await storage.updatePet(newPet);
      expect(storage.pets.first.name, 'Rocky Balboa');

      await storage.deletePet('new-pet-99');
      expect(storage.totalPets, initialCount);
    });
  });

  group('AuthService Tests', () {
    test('AuthService login and logout handles credentials', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthService();
      await auth.init();

      expect(auth.isLoggedIn, false);

      // Wrong credentials
      final failed = await auth.login('wrong', '1');
      expect(failed, false);
      expect(auth.isLoggedIn, false);

      // Valid default credentials
      final ok = await auth.login('admin', '1234');
      expect(ok, true);
      expect(auth.isLoggedIn, true);
      expect(auth.userName, 'admin');

      // Logout
      await auth.logout();
      expect(auth.isLoggedIn, false);
    });
  });
}
