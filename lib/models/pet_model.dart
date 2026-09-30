class Pet {
  final String id;
  String name;
  String owner;
  String contact;
  String type; // Dog, Cat, Bird, Rabbit, Other
  String breed;
  String age;
  String weight; // e.g. "12 kg"
  String gender; // Male, Female
  String healthStatus; // Healthy, Needs Checkup, Vaccinated, Treatment
  String? image;
  String notes;
  bool isVaccinated;

  Pet({
    required this.id,
    required this.name,
    required this.owner,
    this.contact = '+1 (555) 019-2834',
    required this.type,
    this.breed = 'Mixed Breed',
    required this.age,
    this.weight = '5.0 kg',
    this.gender = 'Male',
    this.healthStatus = 'Healthy',
    this.image,
    this.notes = 'Friendly and well behaved.',
    this.isVaccinated = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'owner': owner,
        'contact': contact,
        'type': type,
        'breed': breed,
        'age': age,
        'weight': weight,
        'gender': gender,
        'healthStatus': healthStatus,
        'image': image,
        'notes': notes,
        'isVaccinated': isVaccinated,
      };

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: json['name'] ?? '',
        owner: json['owner'] ?? '',
        contact: json['contact'] ?? '+1 (555) 019-2834',
        type: json['type'] ?? 'Dog',
        breed: json['breed'] ?? 'Mixed',
        age: json['age'] ?? '1 year',
        weight: json['weight'] ?? '5 kg',
        gender: json['gender'] ?? 'Male',
        healthStatus: json['healthStatus'] ?? 'Healthy',
        image: json['image'],
        notes: json['notes'] ?? '',
        isVaccinated: json['isVaccinated'] ?? true,
      );

  // Default sample pets to populate initial database
  static List<Pet> get samplePets => [
        Pet(
          id: 'pet-1',
          name: 'Bella',
          owner: 'Sarah Jenkins',
          contact: '+1 (555) 234-5678',
          type: 'Dog',
          breed: 'Golden Retriever',
          age: '3 years',
          weight: '28.5 kg',
          gender: 'Female',
          healthStatus: 'Healthy',
          image:
              'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=600&q=80',
          notes: 'Loves playing fetch, very energetic, up to date on rabies shots.',
          isVaccinated: true,
        ),
        Pet(
          id: 'pet-2',
          name: 'Milo',
          owner: 'David Chen',
          contact: '+1 (555) 876-5432',
          type: 'Cat',
          breed: 'British Shorthair',
          age: '2 years',
          weight: '4.8 kg',
          gender: 'Male',
          healthStatus: 'Vaccinated',
          image:
              'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=600&q=80',
          notes: 'Indoor cat, loves tuna treats, calm temperament.',
          isVaccinated: true,
        ),
        Pet(
          id: 'pet-3',
          name: 'Charlie',
          owner: 'Emily Watson',
          contact: '+1 (555) 432-1098',
          type: 'Dog',
          breed: 'French Bulldog',
          age: '1.5 years',
          weight: '11.2 kg',
          gender: 'Male',
          healthStatus: 'Needs Checkup',
          image:
              'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=600&q=80',
          notes: 'Sensitive to heat, slight skin allergy, needs gentle shampoo.',
          isVaccinated: false,
        ),
        Pet(
          id: 'pet-4',
          name: 'Kiwi',
          owner: 'Alex Rivera',
          contact: '+1 (555) 901-2345',
          type: 'Bird',
          breed: 'Sun Conure Parrot',
          age: '4 years',
          weight: '130 g',
          gender: 'Female',
          healthStatus: 'Healthy',
          image:
              'https://images.unsplash.com/photo-1552728089-57bdde30beb3?auto=format&fit=crop&w=600&q=80',
          notes: 'Very vocal in mornings, loves sunflower seeds and bell toys.',
          isVaccinated: true,
        ),
        Pet(
          id: 'pet-5',
          name: 'Snowball',
          owner: 'Olivia Smith',
          contact: '+1 (555) 345-6789',
          type: 'Rabbit',
          breed: 'Holland Lop',
          age: '1 year',
          weight: '1.8 kg',
          gender: 'Female',
          healthStatus: 'Healthy',
          image:
              'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=600&q=80',
          notes: 'Gentle, litter-box trained, loves fresh romaine lettuce.',
          isVaccinated: true,
        ),
      ];
}
