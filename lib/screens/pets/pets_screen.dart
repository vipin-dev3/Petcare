import 'package:flutter/material.dart';
import '../../models/pet_model.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_dialogs.dart';
import '../../widgets/pet_card.dart';

class PetsScreen extends StatefulWidget {
  final StorageService storage;
  final VoidCallback onAddPet;

  const PetsScreen({
    super.key,
    required this.storage,
    required this.onAddPet,
  });

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _sortBy = 'Name';
  bool _isGridView = true;

  final List<String> _categories = ['All', 'Dog', 'Cat', 'Bird', 'Rabbit', 'Other'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Pet> _getFilteredPets() {
    final query = _searchController.text.trim().toLowerCase();

    var list = widget.storage.pets.where((p) {
      // Category filter
      if (_selectedCategory != 'All') {
        if (_selectedCategory == 'Other') {
          if (['dog', 'cat', 'bird', 'rabbit'].contains(p.type.toLowerCase())) {
            return false;
          }
        } else if (p.type.toLowerCase() != _selectedCategory.toLowerCase()) {
          return false;
        }
      }

      // Search query filter
      if (query.isNotEmpty) {
        final matchesName = p.name.toLowerCase().contains(query);
        final matchesOwner = p.owner.toLowerCase().contains(query);
        final matchesBreed = p.breed.toLowerCase().contains(query);
        final matchesStatus = p.healthStatus.toLowerCase().contains(query);
        return matchesName || matchesOwner || matchesBreed || matchesStatus;
      }

      return true;
    }).toList();

    // Sort
    if (_sortBy == 'Name') {
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_sortBy == 'Owner') {
      list.sort((a, b) => a.owner.toLowerCase().compareTo(b.owner.toLowerCase()));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredPets = _getFilteredPets();

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
                      '🐾 Pets Directory',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Browse, search, and manage complete pet profiles & health status',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: widget.onAddPet,
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Register Pet', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Search Bar & Filter Controls Container
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Search TextField
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search by pet name, owner, breed, or status...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Sort dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sortBy,
                            icon: const Icon(Icons.sort_rounded, size: 20),
                            items: const [
                              DropdownMenuItem(value: 'Name', child: Text('Sort: Name')),
                              DropdownMenuItem(value: 'Owner', child: Text('Sort: Owner')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _sortBy = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Grid / List toggle
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.grid_view_rounded,
                                size: 20,
                                color: _isGridView ? AppColors.primary : AppColors.lightTextMuted,
                              ),
                              onPressed: () => setState(() => _isGridView = true),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.view_list_rounded,
                                size: 20,
                                color: !_isGridView ? AppColors.primary : AppColors.lightTextMuted,
                              ),
                              onPressed: () => setState(() => _isGridView = false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Species Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        int count = 0;
                        if (cat == 'All') {
                          count = widget.storage.pets.length;
                        } else if (cat == 'Other') {
                          count = widget.storage.otherCount;
                        } else {
                          count = widget.storage.pets
                              .where((p) => p.type.toLowerCase() == cat.toLowerCase())
                              .length;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text('$cat ($count)'),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) setState(() => _selectedCategory = cat);
                            },
                            selectedColor: AppColors.primarySubtle,
                            checkmarkColor: AppColors.primaryDark,
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
                ],
              ),
            ),

            const SizedBox(height: 24),

            // PETS LIST / GRID
            if (filteredPets.isEmpty)
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
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No pet records found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try tweaking your search keywords or clear the category filters.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: widget.onAddPet,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Register New Pet'),
                    ),
                  ],
                ),
              )
            else if (_isGridView)
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 1100) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth > 650) {
                    crossAxisCount = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      childAspectRatio: 0.74,
                    ),
                    itemCount: filteredPets.length,
                    itemBuilder: (context, index) {
                      final pet = filteredPets[index];
                      return PetCard(
                        pet: pet,
                        animationIndex: index,
                        onTap: () => CustomDialogs.showPetDetails(
                          context,
                          pet,
                          onEdit: () async {
                            final updated = await CustomDialogs.showAddEditPetDialog(context, pet: pet);
                            if (updated != null) {
                              await widget.storage.updatePet(updated);
                              setState(() {});
                            }
                          },
                        ),
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
                            title: 'Delete Pet Record?',
                            message: 'Are you sure you want to permanently delete ${pet.name}?',
                          );
                          if (confirmed == true) {
                            await widget.storage.deletePet(pet.id);
                            setState(() {});
                          }
                        },
                      );
                    },
                  );
                },
              )
            else
              // ListView Mode
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPets.length,
                itemBuilder: (context, index) {
                  final pet = filteredPets[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onTap: () => CustomDialogs.showPetDetails(context, pet),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primarySubtle,
                        child: Text(
                          pet.name.isNotEmpty ? pet.name[0] : 'P',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            pet.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              pet.type,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text('${pet.breed} • Owner: ${pet.owner} • Age: ${pet.age} • ${pet.weight}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            tooltip: 'Edit',
                            onPressed: () async {
                              final updated = await CustomDialogs.showAddEditPetDialog(context, pet: pet);
                              if (updated != null) {
                                await widget.storage.updatePet(updated);
                                setState(() {});
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                            tooltip: 'Delete',
                            onPressed: () async {
                              final confirmed = await CustomDialogs.showDeleteConfirm(
                                context,
                                title: 'Delete Pet?',
                                message: 'Are you sure you want to remove ${pet.name}?',
                              );
                              if (confirmed == true) {
                                await widget.storage.deletePet(pet.id);
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
