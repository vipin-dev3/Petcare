import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(PetCareApp());
}

// ================= MODEL =================
class Pet {
  String name;
  String owner;
  String type;
  String age;
  String? image;

  Pet({
    required this.name,
    required this.owner,
    required this.type,
    required this.age,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'owner': owner,
        'type': type,
        'age': age,
        'image': image,
      };

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        name: json['name'],
        owner: json['owner'],
        type: json['type'],
        age: json['age'],
        image: json['image'],
      );
}

// ================= MAIN APP =================
class PetCareApp extends StatefulWidget {
  @override
  State<PetCareApp> createState() => _PetCareAppState();
}

class _PetCareAppState extends State<PetCareApp> {
  bool darkMode = false;
  bool isLoggedIn = false;

  void login() => setState(() => isLoggedIn = true);
  void logout() => setState(() => isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      home: isLoggedIn
          ? PetDashboard(
              toggleTheme: () => setState(() => darkMode = !darkMode),
              logout: logout,
            )
          : LoginPage(onLogin: login),
    );
  }
}

// ================= LOGIN PAGE =================
class LoginPage extends StatelessWidget {
  final VoidCallback onLogin;

  LoginPage({required this.onLogin});

  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🐾 PetCare Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              TextField(
                controller: userController,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (userController.text == "admin" &&
                      passController.text == "1234") {
                    onLogin();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid Login")));
                  }
                },
                child: Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ================= DASHBOARD =================
class PetDashboard extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback logout;

  PetDashboard({required this.toggleTheme, required this.logout});

  @override
  State<PetDashboard> createState() => _PetDashboardState();
}

class _PetDashboardState extends State<PetDashboard> {
  List<Pet> pets = [];
  List<Pet> filteredPets = [];

  final nameController = TextEditingController();
  final ownerController = TextEditingController();
  final typeController = TextEditingController();
  final ageController = TextEditingController();
  final searchController = TextEditingController();

  int? editIndex;
  String? imageBase64;

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  // STORAGE
  Future<void> savePets() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("pets", jsonEncode(pets.map((e) => e.toJson()).toList()));
  }

  Future<void> loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("pets");
    if (data != null) {
      List decoded = jsonDecode(data);
      pets = decoded.map((e) => Pet.fromJson(e)).toList();
      filteredPets = pets;
      setState(() {});
    }
  }

  // CRUD
  void savePet() {
    final pet = Pet(
      name: nameController.text,
      owner: ownerController.text,
      type: typeController.text,
      age: ageController.text,
      image: imageBase64,
    );

    if (editIndex == null) {
      pets.add(pet);
    } else {
      pets[editIndex!] = pet;
      editIndex = null;
    }

    clearFields();
    filterPets("");
    savePets();
  }

  void editPet(int index) {
    final pet = filteredPets[index];
    nameController.text = pet.name;
    ownerController.text = pet.owner;
    typeController.text = pet.type;
    ageController.text = pet.age;
    imageBase64 = pet.image;
    editIndex = pets.indexOf(pet);
  }

  void deletePet(int index) {
    pets.remove(filteredPets[index]);
    filterPets(searchController.text);
    savePets();
  }

  void clearFields() {
    nameController.clear();
    ownerController.clear();
    typeController.clear();
    ageController.clear();
    imageBase64 = null;
  }

  void filterPets(String query) {
    filteredPets = pets
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }

  void pickImage() {
    html.FileUploadInputElement upload = html.FileUploadInputElement();
    upload.accept = 'image/*';
    upload.click();

    upload.onChange.listen((event) {
      final file = upload.files!.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          imageBase64 = reader.result as String;
        });
      });
    });
  }

  int countType(String type) =>
      pets.where((p) => p.type.toLowerCase() == type).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🐾 PetCare Dashboard"),
        actions: [
          IconButton(
              icon: Icon(Icons.dark_mode),
              onPressed: widget.toggleTheme),
          IconButton(icon: Icon(Icons.logout), onPressed: widget.logout)
        ],
      ),
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 200,
            color: Colors.green,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text("Menu", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),

          // MAIN
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: filterPets,
                    decoration: InputDecoration(
                      hintText: "Search pets...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      stat("Total", pets.length),
                      stat("Dogs", countType("dog")),
                      stat("Cats", countType("cat")),
                    ],
                  ),

                  SizedBox(height: 20),

                  Expanded(
                    child: Row(
                      children: [
                        // FORM
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  input(nameController, "Name"),
                                  input(ownerController, "Owner"),
                                  input(typeController, "Type"),
                                  input(ageController, "Age"),

                                  ElevatedButton(
                                      onPressed: pickImage,
                                      child: Text("Upload Image")),

                                  if (imageBase64 != null)
                                    Image.network(imageBase64!, height: 100),

                                  ElevatedButton(
                                      onPressed: savePet,
                                      child: Text("Save Pet")),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 20),

                        // LIST
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredPets.length,
                            itemBuilder: (context, index) {
                              final pet = filteredPets[index];
                              return Card(
                                child: ListTile(
                                  leading: pet.image != null
                                      ? Image.network(pet.image!, width: 50)
                                      : null,
                                  title: Text(pet.name),
                                  subtitle: Text(
                                      "${pet.owner} | ${pet.type} | ${pet.age}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () => editPet(index)),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () => deletePet(index)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget input(controller, label) => Padding(
        padding: EdgeInsets.all(8),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget stat(String title, int value) => Expanded(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(value.toString(),
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(title),
              ],
            ),
          ),
        ),
      );
}